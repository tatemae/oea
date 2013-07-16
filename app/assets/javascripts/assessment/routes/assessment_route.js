var Assessment = require('../models/assessment');
AssessmentRoute = Ember.Route.extend({

  model: function(params){
    return Assessment.find(params.assessment_id);
  },

  afterModel: function(assessment, transition){
    var assessment_promise = Assessment.find(assessment.id);
    assessment_promise.then(function(assessment){
      this.transitionTo('sections', assessment.sections()); // Call Assessment.find to ensure that we have a fully loaded assessment
    }.bind(this));
    return assessment_promise;
  }

});

module.exports = AssessmentRoute;