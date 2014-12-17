//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require libs/md5


$(document).ready(function() {
  
  //
  // Scripts for the assessments/show page
  //
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

  function updateEmbedCode(shouldInclude, value, insertAfter){
    var embed = $('[name=embed_text]').text().replace(value, '');
    if(shouldInclude){
      var index = 0;
      if(insertAfter){
       index = embed.indexOf(insertAfter) + insertAfter.length;
      }
      embed = insertAt(embed, index, value)
    }
    $('[name=embed_text]').text(embed);
  }

  function insertAt(sourceString, index, insertString){
    if (index > 0)
      return sourceString.substring(0, index) + insertString + sourceString.substring(index, sourceString.length);
    else
      return sourceString + insertString;
  }

  function updateScriptInclude(){
    var resizeScript = '<script src="' + window.location.origin + '/assets/openassessments.js" type="text/javascript"></script>';
    updateEmbedCode($('#resize_script:checked').length > 0, resizeScript);
  }
  updateScriptInclude();
  $('#resize_script').on('click', updateScriptInclude);

  function updateConfidenceInclude(){
    updateEmbedCode($('#confidence_levels:checked').length > 0, 'confidence_levels=true&', 'assessments/load?');
  }  
  updateConfidenceInclude();
  $('#confidence_levels').on('click', updateConfidenceInclude);

});
