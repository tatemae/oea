import Base from "./base";

export default Base.extend({

  // TODO change this to a get - maybe even just use an image on the page with the params so we don't run into cross origin issues.
  save: function(){
    $.post(this.get('resultsEndPoint') + '/item_results',
    {
      assessment_id: this.get('assessment.id'),
      user_id: this.get('user_id'),
      item_id: this.get('item_id'),
      identifier: this.get('item_id'),
      eid: this.get('eid'),
      session_status: this.get('session_status'),
      time_elapsed: this.get('time_spent'),
      confidence_level: this.get('confidence_level')
    },
    function(data){
    }, "json");
  }

});
