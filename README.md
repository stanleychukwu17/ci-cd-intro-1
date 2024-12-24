# Github Actions build and deployment of node.js api

- create a new github repo for the project

- create branch protection rule for the main branch and require at-least one review before merging into
the main branch

- write a workflow for testing the code anytime we create a PR for the main branch

- fix any issues with the code and merge into the main branch (jest test)

- write a github-actions workflow that deploys the code to aws staging

- maybe run cypress test against the staging environment

- if everything is okay with your cypress test, then deploy your application to the production environment