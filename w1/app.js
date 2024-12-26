const express = require('express');
require('dotenv').config();
const app = express();

// for logging
const morgan = require('morgan');
app.use(morgan('combined'));  // 'combined' is a standard log format

// for security
const helmet = require('helmet');
app.use(helmet());

// for CORS (Cross-Origin Resource Sharing)
const cors = require('cors');
app.use(cors());

// for rate limiting
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
    windowMs: 2 * 60 * 1000, // 2 minute
    max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Get the PORT
const port = process.env.PORT || 3000;

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

// 