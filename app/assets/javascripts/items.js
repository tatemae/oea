// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('.embed_code').slideUp('slow', function(){});
  $('.embed_button').on('click', function(e){
    e.preventDefault();
    var $self = $(this).closest('.question');
    if ($self.find('.embed_code').is(":hidden")) {
      $self.find('.embed_code').slideDown(function(){
        $self.find('.embed_text').select();
      });
    } else {
      $self.find('.embed_code').slideUp();
    }
  });
  $('.btn-check-answer').on('click', function(e){
    e.preventDefault();
  });
  $('.radio').on('click', function(e){
    var $button = $(this).closest('.question').find('.btn-check-answer');
    if($button.hasClass('disabled')){
      $button.removeClass('disabled');
      $button.addClass('btn-info');
      $button.on('click', function(e){
        e.preventDefault();
        $self = $(this).closest('.question');
        $.ajax({
          type: "POST",
          url:  $self.find('form').attr('action') + "?&authenticity_token=" + $self.find('input[name=authenticity_token]').attr('value'),
          data: $self.find('form').serialize(),
          dataType: 'json',
          success: function(data, status){
            $self.find('.check_answer_result').empty().prepend(data.html);
            $self.find('.tooltip-inner').fadeIn();
            // if(parent){ // We can add this in later on if we decide that we want to just call the parent window for some reason (other 3rd party integrations, MIT, etc)
            //   parent.postMessage(data, '*');
            // }
            if ($('.at_the_end').val("true")){
              window.top.postMessage(data, '*'); // In OT the view is in an iframe but the code we have to call is in the parent of that iframe. This will send a message to the top window.
            }
          },
          error: function(jqxhr, status, errorThrown){
            $self.find('.check_answer_result').empty().prepend(jqxhr.responseText);
            console.log(jqxhr.responseText);
          }
        });
      });
    }
  });
});

$(window).ready(function () {
  $(".edit_item").each(function(index, value){
    $value = $(value);
    var height = $value.outerHeight(true);
    $('.embed_code', $value.parent()).html( function(index, oldhtml){
       return oldhtml.replace(/height='[0-9]*'/, "height='" + height + "'");
    });
  });
});
