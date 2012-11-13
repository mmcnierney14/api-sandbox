(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  (function($) {
    return $.fn.sandbox_for = function(method, path) {
      var context, form, getResponse, match, name, param_names, params, symbol, symbol_names, symbols, value, _i, _j, _len, _len2;
      symbols = (match = path.match(new RegExp(/:.+?(?=\/)|:.+?$/g))) ? match : [];
      params = path.indexOf("?") > -1 ? $.deparam.querystring(path) : [];
      for (name in params) {
        value = params[name];
        if (_.isArray(value)) {
          params[name + "[]"] = params[name];
          delete params[name];
        }
      }
      param_names = _.keys(params);
      symbol_names = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = symbols.length; _i < _len; _i++) {
          symbol = symbols[_i];
          _results.push(symbol.replace(":", ""));
        }
        return _results;
      })();
      form = "<div id='sandbox_input'>      <div id='path_info'>        <div id='get'>" + method + "</div>        <div id='path'>" + path + "</div>      </div>      <div id='fields'>        <form id='symbols'>";
      for (_i = 0, _len = symbol_names.length; _i < _len; _i++) {
        name = symbol_names[_i];
        form += "        <label>" + name + "<input id='sandbox_text_field' type='text' name='" + name + "'></label>";
      }
      form += "</form><form id='params'>";
      for (_j = 0, _len2 = param_names.length; _j < _len2; _j++) {
        name = param_names[_j];
        form += "        <label>" + name + "<input id='sandbox_text_field' type='text' name='" + name + "'></label>";
      }
      form += "<button id='sandbox_try_button'>Try it</button>        </form>      </div>    </div>";
      form += "<div id='sandbox_response'></div>";
      this.html(form);
      context = this;
      this.find("#path_info").click(function() {
        context.find("#fields").slideToggle('fast');
        if (context.find("#sandbox_response").css("display") === "block") {
          return context.find("#sandbox_response").fadeOut('fast');
        }
      });
      getResponse = function() {
        var call_path, symbol, value, _ref;
        call_path = path;
        _ref = context.find("#symbols").serializeToJSON();
        for (symbol in _ref) {
          value = _ref[symbol];
          call_path = call_path.replace(new RegExp(":" + symbol + "(?=[\/?])", "i"), value);
        }
        call_path = $.param.querystring(call_path.split("?")[0], context.find("#params").serializeToJSON());
        $.ajax({
          url: call_path,
          type: method,
          error: __bind(function(jqXHR, textStatus, errorThrown) {
            return context.find("#sandbox_response").html(("AJAX Error: " + textStatus + "\n\nResponse:\n") + JSON.stringify(jqXHR, null, "\t"));
          }, this),
          success: __bind(function(data, textStatus, jqXHR) {
            return context.find("#sandbox_response").html(JSON.stringify(data, null, "\t"));
          }, this)
        });
        return context.find("#sandbox_response").fadeIn('fast');
      };
      this.find("button").click(function() {
        return getResponse();
      });
      this.find("#params").submit(function() {
        getResponse();
        return false;
      });
      return this.find("#symbols").submit(function() {
        getResponse();
        return false;
      });
    };
  })(jQuery);
}).call(this);
