/*
* CBRAIN Project
*
* Copyright (C) 2008-2012
* The Royal Institution for the Advancement of Learning
* McGill University
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.query
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*/

/*
* Author: Natacha Beck <natacha.beck@mcgill.ca>
*/

/**
* TODO general doc
*/

"use strict";

exports.cbrainAPI = function(cbrain_server_url) {
  if (! cbrain_server_url) { throw new Error("Need to be provided with 'cbrain_server_url'."); };
  cbrain_server_url = cbrain_server_url.replace(/\/*$/,"/");

  var authenticity_token = undefined;

  var request = require('request').defaults({
        jar: true,
        headers: {'Accept': 'application/json'},
      });

  var session = {

    //////////////////////////////////////////////
    // Authentication and licenses
    //////////////////////////////////////////////

    /**
    * Connects to the server, supplies the credentials
    * and maintains the tokens necessary for the session.
    *
    *   agent.login('jack', '&jill')
    *
    */
    login: function(username, password, callback) {
      if (!username) {callback("Need to be provided with a username."); return;};
      if (!password) {callback("Need to be provided with a password."); return;};

      setAuthToken( function(err, response) {
        createSession(username, password, function(err,response) {
          err ? callback(err) : callback(null,response);
        });
      });
    },

    //////////////////////////////////////////////
    // Some generic method
    //////////////////////////////////////////////

    /**
    * @doc function
    * @name index
    * @param {string} controller name to specify the request.
    * @param {obj} filters is an optional list of attribute.
    * @param {function} callback Callback function.
    * @description
    * A wrapper method for all index method.
    */
    index: function(controller, filters, callback) {
      if (!controller) {callback("Need to be provided with a controller name."); return;};

      var path = "/" + controller;
      // Construct the form hash
      filters = filters === null || (typeof filters !== 'undefined') ? filters : {};

      var form = {
        update_filter: "filter_hash",
        clear_filter:  "filter_hash",
      };
      merge_options(form,filters);

      // Do the request
      doRequest("GET", path, form, function (err, response, body) {
        var parsed = parse_json_body(body);
        if (!parsed) {
          var status_code = response.statusCode;
          callback("Cannot parsed JSON response in index of " + controller + " response status code: " + status_code);
        } else {
          callback(null,parsed);
        };
      });
    },

    /**
    * @doc function
    * @name show
    * @param {string} controller name to specify the request.

    * @param {string} path to specify the request.
    * @param {number} an id.
    * @param {function} callback Callback function.
    * @description
    * A wrapper method for all show method.
    */
    show: function(controller, id, callback) {
      if (!controller) {callback("Need to be provided with a controller name."); return;};
      if (!id)         {callback("Need to be provided with an id");return;};

      var path = "/" + controller + "/" + id;
      doRequest("GET", path, {}, function (err, response, body ) {
        var parsed = parse_json_body(body);
        if (!parsed) {
          var status_code = response.statusCode;
          callback("Cannot parsed JSON response in show, response status code: " + status_code );
        } else {
          callback(null,parsed);
        };
      });
    },

    //////////////////////////////////////////////
    // Data Registration
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // DataProviders Actions
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // Userfiles Actions
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // Userfiles Actions
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // DataProviders Monitoring
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // Computing Site Monitoring
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // Users Actions
    //////////////////////////////////////////////

    //////////////////////////////////////////////
    // Tasks Actions
    //////////////////////////////////////////////

  };


  //////////////////////////////////////////////
  // Low method called by login
  //////////////////////////////////////////////

  // Set the authenticity_token
  function setAuthToken(callback) {
    var form = {};
    doRequest( "GET", "/session/new", form, function (err, response, body) {
      if (err) {callback(errorr); return;};
      var parsed         = parse_json_body(body);
      authenticity_token = parsed.authenticity_token;

      if (!authenticity_token) {
        callback("Cannot obtain authentication token?!? Server response:" + parsed);
      } else {
        callback(null,authenticity_token);
      };
    });
  };

  // Create a new session
  function createSession(username, password, callback) {
    if (!username) {callback("Need to be provided with a username."); return;};
    if (!password) {callback("Need to be provided with a password."); return;};

    var form = { login: username,
                 password: password
               };
    doRequest("POST", "/session", form, function (err, response, body) {
     if (err) {callback(err); return;};
     callback(null,true);
   });
  };


  //////////////////////////////////////////////
  // Low level methods
  //////////////////////////////////////////////

  /**
  * @doc function
  * @name doRequest
  * @param {string} method must be a HTTP action (one of :POST, :GET, :PUT, or :DELETE).
  * @param {sting} path is a relative path to append to the URL of the main's URI.
  * @param {obj} form is a hash table to sets body to a querystring representation of value.
  * @param {function} callback Callback function.
  * @description
  * LOW LEVEL METHOD. Used by the other high level methods
  * of thi API.
  *
  */
  function doRequest(method, path, form, callback) {
    // TODO: Check if throw works
    if (!method) { callback("Need HTTP method (POST, GET, etc)."); return; };
    if (!path)   { callback("Need CBRAIN route."); return; };

    if (method.match(/GET|HEAD/)) {
      // nothing special to do for the moment
    }
    // POST, DELETE etc
    else {
      merge_options( form, {authenticity_token: authenticity_token});
    }

    var url  = cbrain_server_url; // # contains trailing /
        path = path.replace(/^\/*/,"");
    var uri  = url + path; // slash is inside url

    var request_options = {
      method: method,
      uri:    uri,
      form:   form,
    };

    request(request_options, callback);
  };

  // Decode the json BODY of a reply.
  // Returns the parsed JSON. If anything went wrong,
  // set the internal error message and returns nil.
  function parse_json_body(body) {
    var parsed = undefined;
    try {
      parsed = JSON.parse(body);
    } catch (e) {
      return null;
    }
    return parsed;
  };

  return session;
};

// Utility method in order to concat to obj.
function merge_options(obj1,obj2){
  Object.keys(obj2).forEach(function(key) {
    obj1[key] = obj1[key] || obj2[key];
  })
};

