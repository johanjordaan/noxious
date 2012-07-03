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

// { error : false|'', ajax_url:'', redirect_url:'', html:''    }
var connect_submit = function(source,target) {
 $(source).submit(function(event) {
    event.preventDefault(); 
    var jsonFormData = form2json(source)
    $.post( $(source).attr('action'), jsonFormData ,function( post_response ) {
      if(post_response.errors != undefined) {
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
      }
    });
  });
}