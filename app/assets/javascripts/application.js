//= require jquery
//= require jquery_ujs
//= require bootstrap


$(document).ready(function() {
  $('.embed_button').on('click', function(e){
    e.preventDefault();
    var container = $(e.target).closest('.assessment_meta');
    if(container.find('.embed_code').is(":hidden")) {
      container.find('.embed_code').slideDown(function(){
        container.find('.embed_text').select();
      });
    } else {
      container.find('.embed_code').slideUp();
    }
  });

});