const express = require('express');
require('dotenv').config();
const app = express();

// for logging
if (process.env.NODE_ENV === "production") {
    const morgan = require('morgan');
    app.use(morgan('combined'));  // 'combined' is a standard log format
}
// console.log(process.env.NODE_ENV)

// for security
const helmet = require('helmet');
app.use(helmet());

// for CORS (Cross-Origin Resource Sharing)
const cors = require('cors');
app.use(cors());

// Check if process.env.PORT is set, if not, throw an error
if (!process.env.PORT) {
    throw new Error('The PORT environment variable is not defined!');
}
const port = process.env.PORT;

/* GET home page. */
app.get('/', function (req, res, next) {
    res.status(200).json({ title: 'Nimble-ICE' })
})
  
/* GET ice-flakes resource */
app.get('/ice-flakes', function (req, res, next) {
    res.status(201)
        .json({
            resource: 'ice-flakes',
            count: 1005,
            shape: 'rectangle'
        })
})

module.exports = app