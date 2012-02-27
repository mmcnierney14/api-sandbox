(($) ->
  $.APIExplorer = (describe_api_path, initial_path = "/") ->
    # Wrap everything in an ajax call so that the code has access to the
    # API data from the server
    $.get(describe_api_path, (routes) ->
  
      # Describe the API
      window.api_routes = routes
      window.api_methods = _.uniq(_.map(api_routes, (r) -> r.method ))
        
      highlightTab = (tab) ->
        $(".tab").each ->
          $(this).removeClass("current_tab_item")
        tab.addClass("current_tab_item")
    
      getResponse = ->
        highlightTab $(".formatted_tab")
        $('#response').html("").removeClass("loaded").addClass("loading")
        $("#response").removeClass("no-padding")
        $('#explorer_output').css("display","block")
        $.ajax
          url: $.trim($(".path_input").val())
          type: window.method
          error: (jqXHR, textStatus, errorThrown) =>
            @formatted_data = false
            @table_data = false
            @raw_data = false
            $('#response').removeClass("loading").addClass("loaded").html "AJAX Error: #{textStatus}\n\nResponse:\n"+JSON.stringify(jqXHR,null,"\t")
          success: (data, textStatus, jqXHR) =>
            @formatted_data = JSON.stringify(data,null,"\t")
            @table_data = prettyPrint(data)
            @raw_data = JSON.stringify(data)
            $('#response').removeClass("loading").addClass("loaded").html formatted_data

      # Populate method dropdown with current method at the top
      populateMethodDropdown = (current_method,api_methods) ->
        if api_methods.length > 1
          temp = api_methods[0]
          idx = api_methods.indexOf(current_method)
          api_methods[0] = api_methods[idx]
          api_methods[idx] = temp
    
          dropdown = "
          <li id='#{api_methods[0]}' class='expandable'>
            <p>#{api_methods[0]}</p>
            <ul>"
          for m in api_methods[1..api_methods.length-1]
            dropdown += "<li id='#{m}'><p>#{m}</p></li>"
          dropdown += "
            </ul>
          </li>"
    
          $(".method ul.dropdown").html dropdown
    
          # Reactivate click event on the dropdown menu elements
          $(".method li").click ->
            window.method = $(this).attr('id')
            populateMethodDropdown(method,api_methods)
    
        else
          $(".method ul").html("<li id='#{api_methods[0]}'><p>#{api_methods[0]}</p></li>")

      # Initialize console
      $("#path_input").val(initial_path)
      getResponse()
      populateMethodDropdown("GET",api_methods) if api_methods
      window.method = "GET"

      # Get response when form is submitted
      $(".try_button").click ->
        getResponse()
      $(".path_input").keypress (event) ->
        if (event.which == 13)
          getResponse()

      # Change formatting of response and highlight the current
      # tab item
      $(".formatted_tab").click ->
        highlightTab $(this)
        $("#response").removeClass("no-padding")
        $('#response').html formatted_data if formatted_data
        return false
      $(".table_tab").click ->
        highlightTab $(this)
        $("#response").addClass("no-padding")
        $('#response').html table_data if table_data
        return false
      $(".raw_tab").click ->
        highlightTab $(this)
        $("#response").removeClass("no-padding")
        $('#response').html raw_data if raw_data
        return false

      # Add autocomplete to search for API paths
      $('#path_input').autocomplete({
        source: (req, responseFn) ->
          # Select paths with similar path elements
          results = _.select(api_routes, (r) ->
            path_elements = r.path.replace("(.:format)","").split("/")
            term_elements = req.term.split(/[\/?&]/)
        
            match = false
            for el in term_elements
              break if match
              for path_el in path_elements
                match = true if path_el.match(new RegExp("^"+el,"g"))
                break if match
        
            match && r.method == window.method
          )
          # Wrap them in a clean object
          results = _.map(results, (r) ->
            path: r.path.replace("(.:format)","")
            params: r.params
          )
          # Sort them by their similarity (from the beginning of the string) to the search term
          results = _.sortBy(results, (r) ->
            term_test = req.term + "$"
            path_test = r.path + "."
            index = -1
            for pair in _.zip(path_test.split(""),term_test.split(""))
              index++
              return -index if pair[0] != pair[1]
          )
          responseFn results
        select: ( event, ui ) ->
          $('#path_input').val(ui.item.path)
          return false
      }).data("autocomplete")._renderItem = (ul, item) ->
          html = "
              <a>
              <span class='path'>#{item.path}</span>"
          html += "<span id='params' class='params'>params: #{item.params.join(', ')}</span>" if item.optional_params
          html += "<span id='required' class='params'>params: #{item.params.join(', ')}</span>" unless item.params.join("") == ""
          html += "</a>"
          item = $('<li>').data("item.autocomplete", item).append(html).appendTo(ul)
    )
) (jQuery)