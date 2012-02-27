(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  (function($) {
    return $.APIExplorer = function(describe_api_path, initial_path) {
      if (initial_path == null) {
        initial_path = "/";
      }
      return $.get(describe_api_path, function(routes) {
        var getResponse, highlightTab, populateMethodDropdown;
        window.api_routes = routes;
        window.api_methods = _.uniq(_.map(api_routes, function(r) {
          return r.method;
        }));
        highlightTab = function(tab) {
          $(".tab").each(function() {
            return $(this).removeClass("current_tab_item");
          });
          return tab.addClass("current_tab_item");
        };
        getResponse = function() {
          highlightTab($(".formatted_tab"));
          $('#response').html("").removeClass("loaded").addClass("loading");
          $("#response").removeClass("no-padding");
          $('#explorer_output').css("display", "block");
          return $.ajax({
            url: $.trim($(".path_input").val()),
            type: window.method,
            error: __bind(function(jqXHR, textStatus, errorThrown) {
              this.formatted_data = false;
              this.table_data = false;
              this.raw_data = false;
              return $('#response').removeClass("loading").addClass("loaded").html(("AJAX Error: " + textStatus + "\n\nResponse:\n") + JSON.stringify(jqXHR, null, "\t"));
            }, this),
            success: __bind(function(data, textStatus, jqXHR) {
              this.formatted_data = JSON.stringify(data, null, "\t");
              this.table_data = prettyPrint(data);
              this.raw_data = JSON.stringify(data);
              return $('#response').removeClass("loading").addClass("loaded").html(formatted_data);
            }, this)
          });
        };
        populateMethodDropdown = function(current_method, api_methods) {
          var dropdown, idx, m, temp, _i, _len, _ref;
          if (api_methods.length > 1) {
            temp = api_methods[0];
            idx = api_methods.indexOf(current_method);
            api_methods[0] = api_methods[idx];
            api_methods[idx] = temp;
            dropdown = "          <li id='" + api_methods[0] + "' class='expandable'>            <p>" + api_methods[0] + "</p>            <ul>";
            _ref = api_methods.slice(1, (api_methods.length - 1 + 1) || 9e9);
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              m = _ref[_i];
              dropdown += "<li id='" + m + "'><p>" + m + "</p></li>";
            }
            dropdown += "            </ul>          </li>";
            $(".method ul.dropdown").html(dropdown);
            return $(".method li").click(function() {
              window.method = $(this).attr('id');
              return populateMethodDropdown(method, api_methods);
            });
          } else {
            return $(".method ul").html("<li id='" + api_methods[0] + "'><p>" + api_methods[0] + "</p></li>");
          }
        };
        $("#path_input").val(initial_path);
        getResponse();
        if (api_methods) {
          populateMethodDropdown("GET", api_methods);
        }
        window.method = "GET";
        $(".try_button").click(function() {
          return getResponse();
        });
        $(".path_input").keypress(function(event) {
          if (event.which === 13) {
            return getResponse();
          }
        });
        $(".formatted_tab").click(function() {
          highlightTab($(this));
          $("#response").removeClass("no-padding");
          if (formatted_data) {
            $('#response').html(formatted_data);
          }
          return false;
        });
        $(".table_tab").click(function() {
          highlightTab($(this));
          $("#response").addClass("no-padding");
          if (table_data) {
            $('#response').html(table_data);
          }
          return false;
        });
        $(".raw_tab").click(function() {
          highlightTab($(this));
          $("#response").removeClass("no-padding");
          if (raw_data) {
            $('#response').html(raw_data);
          }
          return false;
        });
        return $('#path_input').autocomplete({
          source: function(req, responseFn) {
            var results;
            results = _.select(api_routes, function(r) {
              var el, match, path_el, path_elements, term_elements, _i, _j, _len, _len2;
              path_elements = r.path.replace("(.:format)", "").split("/");
              term_elements = req.term.split(/[\/?&]/);
              match = false;
              for (_i = 0, _len = term_elements.length; _i < _len; _i++) {
                el = term_elements[_i];
                if (match) {
                  break;
                }
                for (_j = 0, _len2 = path_elements.length; _j < _len2; _j++) {
                  path_el = path_elements[_j];
                  if (path_el.match(new RegExp("^" + el, "g"))) {
                    match = true;
                  }
                  if (match) {
                    break;
                  }
                }
              }
              return match && r.method === window.method;
            });
            results = _.map(results, function(r) {
              return {
                path: r.path.replace("(.:format)", ""),
                params: r.params
              };
            });
            results = _.sortBy(results, function(r) {
              var index, pair, path_test, term_test, _i, _len, _ref;
              term_test = req.term + "$";
              path_test = r.path + ".";
              index = -1;
              _ref = _.zip(path_test.split(""), term_test.split(""));
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                pair = _ref[_i];
                index++;
                if (pair[0] !== pair[1]) {
                  return -index;
                }
              }
            });
            return responseFn(results);
          },
          select: function(event, ui) {
            $('#path_input').val(ui.item.path);
            return false;
          }
        }).data("autocomplete")._renderItem = function(ul, item) {
          var html;
          html = "              <a>              <span class='path'>" + item.path + "</span>";
          html += "</a>";
          return item = $('<li>').data("item.autocomplete", item).append(html).appendTo(ul);
        };
      });
    };
  })(jQuery);
}).call(this);
