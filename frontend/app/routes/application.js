import Assessment from "../models/assessment";
import AssessmentResult from "../models/assessment_result";

export default Ember.Route.extend({

  model: function(params){
    var settings = this.get('settings');

    return new Ember.RSVP.Promise(function(resolve, reject){
      var assessment = Assessment.create({
        qtiUrl: settings.get('qtiUrl')
      });

      assessment.on('loaded', function(){
        resolve(assessment);
      }.bind(this));

      assessment.on('error', function(){
        reject(new Error("Failed to load assessment"));
      });

      // Record that the assessment was viewed
      var assessmentResult = AssessmentResult.create({
        assessment: assessment,
        resultsEndPoint: settings.get('resultsEndPoint'),
        user_id: settings.get('userId')
      }).save();

    });
  },

  afterModel: function(model, transition){
    if(transition.targetName === 'index'){
      this.transitionTo('sections');
    }
  }

});
