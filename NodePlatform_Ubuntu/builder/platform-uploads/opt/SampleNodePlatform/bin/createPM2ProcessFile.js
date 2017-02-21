//   Copyright 2016-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
//   Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
//
//   http://aws.amazon.com/apache2.0/
//
//   or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

var util = require('util');
var fs = require('fs');

var PROCESS_JSON = "pm2/process.json";
var NODE_LOG = "/var/log/nodejs/nodejs.log";

function getNewProcessApp( startCmd ) {

	var app = {};
	app.name = startCmd;
	app.script = startCmd;
	app.log_file = NODE_LOG;
	app.instances = process.env.WEB_CONCURRENCY || -1;
	app.exec_mode = "cluster";
	app.env = getEnvParams();
	
	return app;
}

function getOptions() {
	var buf = fs.readFileSync( '/var/app/config/envvars.json' );	
	if( buf ) {
		return JSON.parse(buf.toString().trim());
	}
	return {};
}

function getEnvParams(  ) {
	var options = getOptions();
	if(options) {
		var envParams = options['aws:elasticbeanstalk:application:environment'];
		envParams["NODE_ENV"] = "production";
		if (envParams) { return envParams; }
	}
	return { "NODE_ENV" : "production" };
}

function getDefaultStartCommand() {
	var options = getOptions();
	if( options ) {
		var appSettings = options['aws:elasticbeanstalk:container:custom:application'];
		if( appSettings ) {
			var start = appSettings['NPM_START'];
			if( start ) {
				return start.replace("node", "");
			}
		}
	}
	console.log("Could not read the default start from option settings. Quiting.");
	process.exit(1);
	
}


function getStartCmd( pjson ) {
	var scripts = pjson.scripts;
	var startCmd = getDefaultStartCommand();

	if( scripts ) {
		startCmd = scripts.start;
		startCmd = startCmd.replace("node ", "");
	}
	return startCmd.trim();
}

function writePM2ProcessFile( pjson ) {

	console.log("Writing PM2 process.json file - " + PROCESS_JSON );
	var process = {};
	process.apps = [];

	var scripts = pjson.scripts;
	if( scripts ) {
		// add each script to the processes
		Object.keys(scripts).forEach( function(key){
			var val = scripts[key];
			val = val.replace("node", "").trim();
			var app = getNewProcessApp( val );
			process.apps.push(app);
		});
	} else {
		// no script -- so start the default
		var app = getNewProcessApp( getStartCmd(pjson) );
		process.apps.push(app);
	}

	
	fs.writeFileSync( PROCESS_JSON, JSON.stringify(process));
}

process.chdir("/var/app/current");
var pjsonBuf = fs.readFileSync( 'package.json' );
var pjson = JSON.parse( pjsonBuf.toString().trim());
writePM2ProcessFile(pjson);
