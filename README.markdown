API Sandbox jQuery Plugin
=========================

API Sandbox is a jQuery plugin written in CoffeeScript that allows web apps to easily implement sandbox environments for an API explorer. The plugin includes two parts: apiSandbox, which aids in the creation of inline sandboxes for individual API paths, and APIExplorer, which is a full API explorer solution, much like [Facebook's](https://developers.facebook.com/tools/explorer/).

Dependencies
------------

API Explorer's dependencies:

 * [Grape](https://github.com/dblock/grape/tree/api-params) on [dblock](https://github.com/dblock)'s fork (at api-params) is the only supported API
 * [jQuery](http://jquery.com/)
 * [jQuery UI](http://jqueryui.com/download) (just the autocomplete plugin)
 * [Underscore.js](http://documentcloud.github.com/underscore/)
 * [prettyPrint.js](https://github.com/jamespadolsey/prettyPrint.js)
 * [CoffeeScript](http://jashkenas.github.com/coffee-script/)
 * [SASS](http://sass-lang.com/)

API Sandbox's dependencies:

 * [jQuery](http://jquery.com/)
 * [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/)
 * [Underscore.js](http://documentcloud.github.com/underscore/)
 * [CoffeeScript](http://jashkenas.github.com/coffee-script/)
 * [SASS](http://sass-lang.com/)
 
I'd be happy to accept pull requests for versions of API Sandbox without these dependencies.

Usage
-----

###API Explorer

The plugin takes one argument, which is a relative URL to a server path that returns a hash describing the API for a web app. API Explorer accepts a hash with two keys, one with a string for the current version of the API, e.g. `"v1"`, and one with an array of Grape `route` objects.

    $.APIExplorer("describe_api")

For example, a Rails controller could be configured as follows:

    # GET /api/:version/describe_api
    def describe_api
      api_hash = {}
      api_hash['version'] = params[:version]
      api_hash['routes'] = Api::routes
      render json: api_hash
    end
    
API Explorer adds functionality to a template, which has been provided. As long as the skeleton of the template remains with the proper `div` elements still intact, you can modify this template and the accompanying CSS as much as you like.

###API Sandbox

The plugin takes two arguments, one for an HTTP method, and another for the API path. The plugin parses the URL and creates editable fields on the page for each URL parameter so the API path can be tested. Note that if the page has multiple sandboxes, each sandbox must be in its own unique div element.  For example:

    $("#user").sandbox_for("get","/api/v1/users?user_id=")

This would place an API sandbox with one field for user_id in a div element with an id of user on the page.

API Sandbox recognizes URL parameters in three forms: `:symbols`, `?first_param=`, and `&subsequent_params=`. Here's an example with multiple types of params in one URL string:

    $("#user").sandbox_for("get","/api/v1/:model/search?term=&results_per_page=&page=")

This would result in a form with four fields, one for `model`, one for `term`, one for `results_per_page`, and one for `page`.

API Sandbox can be used to easily place interactive sandboxes inline with documentation. See [this blog post](http://mattmcnierney.wordpress.com/2011/08/18/embedding-api-sandboxes-in-documentation/) for information on how to integrate Markdown, Redcarpet 2.0.0, and API Sandbox together to create dynamic docs.

Inspiration
-----------

The API Sandbox plugin was inspired by [Wordnik's excellent API explorer](http://developer.wordnik.com/docs). To easily create an API for your Ruby on Rails web app, use [Grape](https://github.com/intridea/grape). This plugin was tested on an API using Grape.

TODO
----

* Add support for the entry of multiple values for array params (e.g. `?names[]=`). Currently, API Sandbox correctly sends array params as arrays, but there isn't a clean interface to add multiple values to an array param all in the same box. If you need to enter multiple values, then just put multiple array params in the path, e.g. `api/v1/users?names[]=names[]=names[]=`.
* Add more configuration options to APIExplorer