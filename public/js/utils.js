var form2json = function(source) {
  var form = {}
  $(source+' input,select').each(function(index) {
    if($(this).attr('type') == 'checkbox') 
      form[$(this).attr('name')] = $(this).is(':checked');
    else if($(this).attr('type') == 'radio') {
      if($(this).is(':checked'))
        form[$(this).attr('name')] = $(this).val();
    }
    else 
      form[$(this).attr('name')] = $(this).val();
  });
  //for(var k in form)
  //  alert(k+'=='+form[k]);
  
  return form;
}

var json2form = function(target,json) {
  var keys = Object.keys(json);
  for(var i=0;i<keys.length;i++) {
    var input = $(target+' input[name="'+keys[i]+'"],select[name="'+keys[i]+'"]');
    
    if(input.attr('type') == 'password') {
    } else if(input.attr('type') == 'checkbox') {
    } else {
      input.val(json[keys[i]]);
    }
  }
}

var post_process_form = function(target,field_errors) {
  $(target+' input,select').each(function(index) {
    if($(this).attr('type') == 'password')
      $(this).val('');
  });
  var field_error_keys = Object.keys(field_errors);
  for(var feki=0;feki<field_error_keys.length;feki++) {
    $('span[name="'+field_error_keys[feki]+'.error"]').html(field_errors[field_error_keys[feki]]);
  }
}

// Conect something (probably a achor or a button) to a ajax url get. It then 
// renders the response in the target
//
// params.source     = selector for the source element
// params.url        = url to post or get from 
// params.target     = selector for the target element
// params.wait_html  = html to display while waiting     
//
// params.after_load = callback to call after the load has completed
//
// params.form       = if this field is specified then the form will be submitted to the url
//
// 
// connect({ source:"#btn", url:"/get/stuff", target:"#btn_src",  });

var connect = function(params) {
  var source = params.source;
  var url = params.url;
  var target = params.target;
  var wait_html = '<img src="/img/loading.gif"/> Loading ...' ;//params.wait_html;
  var after_load = params.after_load;
  
  var form = params.form==undefined?false:params.form;
    
  if(!form) {  
    $(source).click(function(event) {
      event.preventDefault(); 
      $(target).html(wait_html);
      setTimeout(function() {
        $.get(url, function(data) {
          $(target).html(data);
          if(after_load != undefined)
            after_load();
        });
      },1);
    });
  } else {
    var jsonFormData = form2json(form);
    $(form).submit( function(event) {
      event.preventDefault(); 
      $.post( url , jsonFormData ,function( post_response ) {
        // If there was errors then post process the form to display the errors
        //
        after_load();
        /*if(post_response.errors != undefined) {
          post_process_form(source,post_response.field_errors);
        } else {
          if(post_response.html != undefined) {
            $(target).html(post_response.html);
          } else if(post_response.redirect_url) {
            window.location = post_response.redirect_url;
          } else if(post_response.ajax_url) {
            $.get(post_response.ajax_url, function(get_response) {
              $(target).html(get_response);
              //json2form(source,jsonFormData);
            });
          }
        }*/
      });
    });
  }
  
}

var click = function(selector) {
  setTimeout(function(){
    $(selector).trigger('click');
  },1);
}
