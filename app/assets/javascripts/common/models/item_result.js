Oea.ItemResult = Oea.ModelBase.extend({

  // TODO change this to a get - maybe even just use an image on the page with the params so we don't run into cross origin issues.
  save: function(){
    $.post(this.get('resultsEndPoint') + '/item_results',
    {
      assessment_id: this.get('assessment.id'),
      user_id: this.get('user_id')
    },
    function(data){
    }, "json");
  }

});