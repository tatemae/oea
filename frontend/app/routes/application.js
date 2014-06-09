import Assessment from "../models/assessment";
import AssessmentResult from "../models/assessment_result";

export default Ember.Route.extend({

  beforeModel: function(transition){
    var qtiUrl = this.get('settings').get('qtiUrl');
    if(Ember.isBlank(qtiUrl)){
      throw new Error("No src_url specified: specify a src_url in the url query params.");
    }
  },

  model: function(params){
    var settings = this.get('settings');

    return new Ember.RSVP.Promise(function(resolve, reject){
      var assessment = Assessment.create({
        qtiUrl: settings.get('qtiUrl')
      });

      assessment.on('loaded', function(){
        // Record that the assessment was viewed
        AssessmentResult.create({
          assessment_id: settings.get('assessmentId'),
          identifier: assessment.get('id'),
          eId: settings.get('eId'),
          external_user_id: settings.get('external_user_id'),
          resultsEndPoint: settings.get('resultsEndPoint'),
          src_url: settings.get('qtiUrl'),
          user_id: settings.get('userId')
        }).save().then(function(result) {
          assessment.set('assessment_result', result);
          resolve(assessment);
        }.bind(this), function(e) {
          resolve(assessment);
        }.bind(this));

      }.bind(this));

      assessment.on('error', function(){
        reject(new Error("Failed to load assessment"));
      });

    });
  },

  afterModel: function(model, transition){
    if(transition.targetName === 'index'){
      this.transitionTo('sections');
    }
  },

  actions: {
    error: function(e) {
      var controller = Ember.ObjectController.create({
        content: e
      });
      this.render('error', {controller: controller});
      return true;
    }
  }
});
