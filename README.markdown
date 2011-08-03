API Sandbox jQuery Plugin
=========================

API Sandbox is a jQuery plugin written in CoffeeScript that allows web apps to easily implement sandbox environments for an API explorer. The design of the sandbox is configurable by editing the sandbox_styles.sass file included in this repository.

Dependencies
------------

API Sandbox has a couple of dependencies:

 * [jQuery](http://jquery.com/)
 * [jQuery BBQ](http://benalman.com/projects/jquery-bbq-plugin/)
 * [Underscore.js](http://documentcloud.github.com/underscore/)
 * [CoffeeScript](http://jashkenas.github.com/coffee-script/)
 * [SASS](http://sass-lang.com/)

If there is interest, I can work on a version of API Sandbox without these dependencies.

Usage
-----

The plugin takes two arguments, one for an HTTP method, and another for the API path. The plugin parses the URL and creates editable fields on the page for each URL parameter so the API path can be tested. Note that if the page has multiple sandboxes, each sandbox must be in its own unique div element.  For example:

    $("#user").apiSandbox("get","/api/v1/users?user_id=")

This would place an API sandbox with one field for user_id in a div element with an id of user on the page.

API Sandbox recognizes URL parameters in three forms: `:symbols`, `?first_param=`, and `&subsequent_params=`. Here's an example with multiple types of params in one URL string:

    $("#user").apiSandbox("get","/api/v1/:model/search?term=&results_per_page=&page=")

This would result in a form with four fields, one for `model`, one for `term`, one for `results_per_page`, and one for `page`.

Important note: if the API path ends with a symbol, it must end with a trailing forward slash (/) to properly parse the path. For example:

    $("#user").apiSandbox("post","/api/v1/:user/:action/")

If the path had been written as `/api/v1/:user/:action`, API Sandbox would not have recognized the second field.

Inspiration
-----------

The API Sandbox plugin was inspired by [Wordnik's excellent API explorer](http://developer.wordnik.com/docs). To easily create an API for your Ruby on Rails web app, use [Grape](https://github.com/intridea/grape). This plugin was tested on an API using Grape.

TODO
----

* Add support for the entry of multiple values for array params (e.g. `?names[]=`).