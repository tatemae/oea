// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('.embed_code').slideUp('slow', function(){});
  $('.embed_button').on('click', function(e){
    e.preventDefault();
    var $self = $(this).closest('.question');
    if ($self.find('.embed_code').is(":hidden")) {
      $self.find('.embed_code').show("slow", function(){
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
          },
          error: function(jqxhr, status, errorThrown){
          }
        });
      });
    }
  });
});

$(document).ready(function () {
  $(".question").each(function(index, value){
    var height = $(value).height();
    $('.embed_code', value).html( function(index, oldhtml){
       return oldhtml.replace(/height='[0-9]*'/, "height='" + height + "'");
    });
  });
});
