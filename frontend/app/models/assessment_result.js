import Base from "./base";
var ajax = require('ic-ajax');

export default Base.extend({

  // TODO change this to a get - maybe even just use an image on the page with the params so we don't run into cross origin issues.
  save: function(){
    var data = {
      assessment_id: this.get('assessment.id'),
      user_id: this.get('user_id'),
      eid: this.get('eid')
    };
    ajax.request(this.get('resultsEndPoint') + '/assessment_results',
      {type: 'POST', data: data, dataType: 'json'});
  }

});
