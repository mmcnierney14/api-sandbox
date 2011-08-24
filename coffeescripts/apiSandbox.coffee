(($) ->
  $.fn.sandbox_for = (method,path) ->
    # Get symbol params and their respective indexes in the path
    symbols = if match = path.match(new RegExp(/:.+?(?=\/)/g)) then match else []
  
    # Get an array of params with jQuery bbq
    params = if path.indexOf("?") > -1 then $.deparam.querystring(path) else []
        
    # Get readable field names 
    for name,value of params
      if _.isArray(value)
        params[name + "[]"] = params[name]
        delete params[name]
    param_names = _.keys params
    symbol_names = for symbol in symbols
      symbol.replace(":","")
    
    # Build form
    form = "<div id='sandbox_input'>
      <div id='path_info'>
        <div id='get'>" + method + "</div>
        <div id='path'>" + path + "</div>
      </div>
      <div id='fields'>
        <form id='symbols'>"
    for name in symbol_names
      form += "
        <label>" + name + "<input id='sandbox_text_field' type='text' name='" + name + "'></label>"
    for name in param_names
      form += "
        <label>" + name + "<input id='sandbox_text_field' type='text' name='" + name + "'></label>"
    form += "<button id='sandbox_try_button'>Try it</button>
        </form>
      </div>
    </div>"
    form += "<div id='sandbox_response'></div>"
    
    # Add form to location's html
    this.html(form)

    context = this
    # Slide down the fields when the path is clicked and make the output
    # disappear if necessary
    this.find("#path_info").click ->
      context.find("#fields").slideToggle('fast')
      context.find("#sandbox_response").fadeOut('fast') if context.find("#sandbox_response").css("display") == "block"

    getResponse = ->
      call_path = path

      # Interpolate symbols into path
      for symbol,value of context.find("#symbols").serializeToJSON()
        call_path = call_path.replace(new RegExp(":"+symbol+"(?=[\/?])","i"),value)

      # Interpolate query values into path
      call_path = $.param.querystring( call_path.split("?")[0], context.find("#params").serializeToJSON())

      # Get the API response
      $.ajax 
        url: call_path,
        type: method,
        error: (jqXHR, textStatus, errorThrown) =>
          context.find("#sandbox_response").html "AJAX Error: #{textStatus}\n\nResponse:\n"+JSON.stringify(jqXHR,null,"\t")
        success: (data, textStatus, jqXHR) =>
          context.find("#sandbox_response").html JSON.stringify(data,null,"\t")
      context.find("#sandbox_response").fadeIn('fast')

    # When the try button is clicked
    this.find("button").click ->
      getResponse()

    # When either of the form is submitted (by the user hitting enter)
    this.find("#params").submit ->
      getResponse()
      return false
    this.find("#symbols").submit ->
      getResponse()
      return false

) (jQuery)