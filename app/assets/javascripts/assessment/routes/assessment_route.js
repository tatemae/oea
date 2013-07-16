var Assessment = require('../models/assessment');
AssessmentRoute = Ember.Route.extend({
  model: function(params){
    return Assessment.findOne(params.assessment_id);
  }
});

module.exports = AssessmentRoute;