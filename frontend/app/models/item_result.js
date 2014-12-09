import Base from "./base";

var ajax = require('ic-ajax');

export default Base.extend({

  // TODO change this to a get - maybe even just use an image on the page with the params so we don't run into cross origin issues.
  save: function(){
    var data = {
      assessment_result_id: this.get('assessment_result_id'),
      identifier: this.get('identifier'),
      eid: this.get('eId'),
      external_user_id: this.get('external_user_id'),
      src_url: this.get('src_url'),
      keywords: this.get("keywords"),
      objectives: this.get("objectives"),
      session_status: this.get('session_status'),
      time_elapsed: this.get('time_spent'),
      confidence_level: this.get('confidence_level'),
      correct: this.get('correct'),
      score: this.get('score')
    };
    var url = this.get('resultsEndPoint') + '/item_results';
    var payload = {type: 'POST', data: data, dataType: 'json'};
    return ajax.request(url, payload);
  }
});
