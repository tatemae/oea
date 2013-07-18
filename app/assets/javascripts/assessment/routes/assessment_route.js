var Assessment = require('../models/assessment');
AssessmentRoute = Ember.Route.extend({

  model: function(params){
    if(params.assessment_id){ this.assessment_id = params.assessment_id; } // Seems crazy but we have to store off the assessment id since when the route model is called later on this value is undefined.
    return Assessment.find(params.assessment_id || this.assessment_id);
  },

  setupController: function(controller, model){
    if(model.id){ this.assessment_id = model.id; }
  },

  afterModel: function(model, transition){
    if(transition.targetName == "assessment.index"){
      this.transitionTo('sections');
    }
  }

});

module.exports = AssessmentRoute;