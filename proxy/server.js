var express = require("express");
const { createProxyMiddleware } = require('http-proxy-middleware');
var app = express();
app.use(
  '/',
  createProxyMiddleware({
    target: "http://soapphoto.com/",
    changeOrigin: true,
  })
);
app.listen(3000);
