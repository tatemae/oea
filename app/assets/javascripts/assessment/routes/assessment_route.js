var Assessment = require('../models/assessment');
AssessmentRoute = Ember.Route.extend({

  model: function(params){
    return Assessment.find(params.assessment_id);
  },

  afterModel: function(assessment, transition){
    this.transitionTo('sections');
  }

});

module.exports = AssessmentRoute;