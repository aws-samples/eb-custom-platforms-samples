//   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
//   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
//
//   http://aws.amazon.com/apache2.0/
//
//   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

var express = require('express');
var app = express();

app.set('view engine', 'ejs');
app.set('view options', { layout: false });
app.use('/public', express.static('public'));

app.use(express.bodyParser());

app.use(app.router);

app.get('/', function (req, res) {
  res.render('index');
});

app.listen(process.env.PORT || 3000);
console.log("Listening on port: " + (process.env.PORT || 3000));
