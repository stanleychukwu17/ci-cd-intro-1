terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "remote" {
    organization = "stanley_single_team"

    workspaces {
      name = "github-actions-cicd"
    }
  }
}

provider "aws" {
  region     = "eu-north-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.project} VPC"
  }
}

resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "${local.project} subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.project} IGW"
  }
}

resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.project} RT"
  }
}

resource "aws_route_table_association" "assoc_1" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_rt.id
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress = [
    { # for ssh connections
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.allowed_ip_address
      description      = "Connection to the ec2 instance using ssh on port 22"
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = null
      security_groups  = null
    },
    { # for http connections on port 80
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = var.allowed_ip_address
      description      = "Connection to the ec2 instance using http on port 80"
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = null
      security_groups  = null
    },
    { # for https connections on port 8080
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = var.allowed_ip_address
      description      = "Connection to the ec2 instance using http  on port 8080"
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = null
      security_groups  = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      self             = true
      prefix_list_ids  = null
      security_groups  = null
    }
  ]

  tags = {
    Name = "${local.project} SG"
  }
}

resource "aws_key_pair" "demo_key" {
  key_name   = "devops-directive-demo-key"
  public_key = var.public_key
}

data "aws_ami" "amazon_linux_img" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "app_vm" {
  ami                         = data.aws_ami.amazon_linux_img.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.web_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.demo_key.key_name
  count                       = 1
  user_data                   = file("./entry-point-amazon-linux.sh")

  tags = {
    Name = "${local.project} EC2"
  }
}