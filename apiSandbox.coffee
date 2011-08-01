(($) ->
  
  # Helpers
  
  # Returns an array of strings of the names of the fields in
  # a URL. Recognizes URL params in three forms -- :symbol,
  # ?first_param=, and &subsequent_params=
  fields_for = (path) ->
    fields = []
    pathElements = path.split("/")
    for e in pathElements
      # Deal with ? params
      if e.indexOf("?") > -1
        args = e.split("?")[1]
        if args.indexOf("&") > -1
          args = args.split("&")
          for arg in args
            fields.push(arg) if arg
        else
          fields.push(args)
      # Deal with symbol path elements
      if e.indexOf(":") > -1
        if e.indexOf("?") > -1
          arg = e.substr(e.indexOf(":"),e.indexOf("?"))
        else
          arg = e
        fields.push(arg)
    return fields

  # Splice string helper
  # From http://stackoverflow.com/questions/4313841/javascript-how-can-i-insert-a-string-at-a-specific-index
  String.prototype.splice = ( idx, rem, s ) ->
    (this.slice(0,idx) + s + this.slice(idx + Math.abs(rem)));

  # Plugin
  $.fn.apiSandbox = (method,path) ->
    
    fields = fields_for(path)
    
    path_id = path.replace(new RegExp(/\/|\?|\=/g),"-")
    # Get field names
    field_names = []
    for field in fields
      field_names.push(field.replace(":","").replace("=",""))
    
    # Generate form
    form = "
      <div id='sandbox_input'>
        <div id='path_info' name='"+path_id+" path_info'>
          <div id='get'>" + method + "</div>
          <div id='path'>" + path + "</div>
        </div>
        <div id='fields' name='"+path_id+" fields'>"
    for name in field_names
      form += "<label>" + name + "</label><input id='sandbox_text_field' type='text' name='" + path_id + name + "'>"
    form += "
        <button id='sandbox_try_button' name='" + path_id + "'>Try It</button>
      </div></div>
    <div id='sandbox_response' name='" + path_id + " response'></div>"
    
    # Add form to location's html
    this.html(form)
    
    # Slide down the fields when the path is clicked and make the output
    # disappear if necessary
    $('div[name="'+path_id+' path_info"]').click ->
      $('div[name="'+path_id+' fields"]').slideToggle('fast')
      if $('div[name="'+path_id+' response"]').css("display") == "block"
        $('div[name="'+path_id+' response"]').fadeOut('fast')
    
    # When the try button is clicked
    $('button[name="'+path_id+'"]').click ->
      call_path = path
      # Fill in the path with the parameters specified in the form
      for field in fields
        f_name = path_id + field.replace(":","").replace("=","")
        if field.indexOf(":") > -1
          call_path = call_path.replace(field,$('input[name="'+f_name+'"]').val())
        if field.indexOf("=") > -1
          call_path = call_path.splice(call_path.indexOf(field)+field.length,0,$('input[name="'+f_name+'"]').val())
      # Get the API response
      $.ajax 
        url: call_path,
        type: method,
        error: (jqXHR, textStatus, errorThrown) =>
          $('div[name="'+path_id+' response"]').html "AJAX Error: #{textStatus}\n\nResponse:\n"+JSON.stringify(jqXHR,null,"\t")
        success: (data, textStatus, jqXHR) =>
          $('div[name="'+path_id+' response"]').html JSON.stringify(data,null,"\t")
      $('div[name="'+path_id+' response"]').fadeIn('fast')

)(jQuery)
