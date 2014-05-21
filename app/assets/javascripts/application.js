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

  $('#confidence_levels').on('click', function(e){
    if( e.currentTarget.checked )
    {
      $('[name=embed_text]').addClass('hidden');
      $('[name=embed_text_confidence_levels]').removeClass('hidden');
    }
    else
    {
      $('[name=embed_text]').removeClass('hidden');
      $('[name=embed_text_confidence_levels]').addClass('hidden');
    }
  });

});
