import Base from "./base";
var ajax = require('ic-ajax');

export default Base.extend({

  // TODO change this to a get - maybe even just use an image on the page with the params so we don't run into cross origin issues.
  save: function(){
    var data = {
      assessment_id: this.get('assessment_id'),
      user_id: this.get('user_id'),
      eId: this.get('eId')
    };
    var url = this.get('resultsEndPoint') + '/assessment_results';
    var payload = {type: 'POST', data: data, dataType: 'json'};
    return ajax.request(url, payload);
  },

  parseAssessmentResult: function(assessment_result) {
    this.setProperties({
      id: assessment_result.id
    });
  }

});
