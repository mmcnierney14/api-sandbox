(($) ->
  
  $.fn.apiSandbox = (method,path) ->
    # Get symbol params and their respective indexes in the path
    symbols = if match = path.match(new RegExp(/:.+?(?=\/)/g)) then match else []
    
    # Get an array of params with jQuery bbq
    params = if path.indexOf("?") > -1 then $.deparam.querystring(path) else []
          
    # Get readable field names
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
    
    # Slide down the fields when the path is clicked and make the output
    # disappear if necessary
    this.find("#path_info").click ->
      this.find("#fields").slideToggle('fast')
      this.find("#sandbox_response").fadeOut('fast') if this.find("#sandbox_response").css("display") == "block"
    
    # When the try button is clicked
    this.find("button").click ->
      call_path = path
      
      # Interpolate symbols into path
      for symbol,value of this.find("#symbols").serializeToJSON()
        call_path = call_path.replace(new RegExp(":"+symbol+"(?=[\/?])","i"),value)
      
      # Interpolate query values into path
      call_path = $.param.querystring( call_path, this.find("#params").serializeToJSON())

      # Get the API response
      $.ajax 
        url: call_path,
        type: method,
        error: (jqXHR, textStatus, errorThrown) =>
          this.find("#sandbox_response").html "AJAX Error: #{textStatus}\n\nResponse:\n"+JSON.stringify(jqXHR,null,"\t")
        success: (data, textStatus, jqXHR) =>
          this.find("#sandbox_response").html JSON.stringify(data,null,"\t")
      this.find("#sandbox_response").fadeIn('fast') 


)(jQuery)
