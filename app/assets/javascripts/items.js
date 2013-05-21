// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('.embed_code').slideUp('slow', function(){})
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
});