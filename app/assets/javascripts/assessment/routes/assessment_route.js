var Assessment = require('../models/assessment');
AssessmentRoute = Ember.Route.extend({

  model: function(params){
    if(params.assessment_id){ this.assessment_id = params.assessment_id; } // Seems crazy but we have to store off the assessment id since when the route model is called later on this value is undefined.
    return Assessment.find(params.assessment_id || this.assessment_id);
  },

  setupController: function(controller, model){ // HACK Would love for this to be afterModel but it sends the route into an infinite loop. We have to use setupController for now. We use this method all the way down the routes.
    if(model.id){ this.assessment_id = model.id; }
    this.transitionTo('sections');
  }

});

module.exports = AssessmentRoute;