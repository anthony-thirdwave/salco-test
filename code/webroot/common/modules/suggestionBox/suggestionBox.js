$(document).ready(function(){
  var $anonymous = $('#anonymousSuggestion')
  var $employee = $('#employeeName')
  var $missive = $('#email')

  function enable_anonymous(){
    disable($employee);
    disable($missive);
  }

  function disable_anonymous(){
    enable($employee);
    enable($missive);
  }

  function disable(element){
    element.val("");
    element.attr('disabled', true)
    element.addClass('disabled');
  }

  function enable(element){
    element.attr('disabled', false);
    element.removeClass('disabled');
  }

  $anonymous.change(function(){
    $anonymous.prop('checked') ?  enable_anonymous() : disable_anonymous()
  })

  $('form#applicationForm').submit(function(){
    $(this).find('input[type=submit]').attr('disabled', 'disabled');
    $('.img_container').removeClass('hidden');
    $('textarea').addClass('hidden');
  });
});