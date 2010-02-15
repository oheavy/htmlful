$('input[type="hidden"]').addClass('hide');
// buttons UI
$('.create_element').addClass('ui-state-default ui-corner-all').hover(function() {
  $(this).addClass("ui-state-hover");
}, function() {
  $(this).removeClass("ui-state-hover");
}).mousedown(function() {
  $(this).addClass("ui-state-active");
}).mouseup(function() {
  $(this).removeClass("ui-state-active");
});

$('.remove_fieldset').live('click', function(event) {
  if (event.which != 3) {
    $(this).parent().prev().find('input[type=hidden]').val(1);
    $($(this).closest('fieldset')).hide('blind');
    return false;
  }
  return true;
});
$('form div.new_nested_element').each(function() {
  var create_button = $(this).children('a.create_element');
  var remove_button = $(this).children('a.remove_element').remove();
  var fragment = $($(this).find('fieldset')[0]).remove();
  var remove_button_function = function(event) {
    if (event.which != 3) {
      $($(this).closest('fieldset')).hide('blind', {}, 1000, function(){$(this).remove();});
      return false;
    }
    return true;
  }
  create_button.click(function(event) {
    var new_fragment = fragment.clone().hide();
    
    var new_remove_button = remove_button.clone();
    new_remove_button.click(remove_button_function);
    
    var nested_inputs = $(this).parent().children('div.nested_inputs');
    nested_inputs.append(new_fragment);

    // this is a necessary hack for rails http://groups.google.com.au/group/formtastic/browse_thread/thread/9358a13bd26a6108
    var unique_id = new Date().getTime();
    new_fragment.find('input').each(function() {
      this.id = this.id && this.id.replace(/NEW_RECORD/, unique_id);
      this.name = this.name && this.name.replace(/NEW_RECORD/, unique_id);
    });
    new_fragment.find('label').each(function() {
      this.htmlFor = this.htmlFor && this.htmlFor.replace(/NEW_RECORD/, unique_id);
    });
    
    $($(this).closest('form')).trigger('element-added', new_fragment);
    new_fragment.append(new_remove_button);
    new_fragment.show('blind');
    return false;
  });
});