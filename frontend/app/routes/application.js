import Ember from 'ember';
import Assessment from "../models/assessment";
import AssessmentResult from "../models/assessment_result";

export default Ember.Route.extend({

  beforeModel: function(transition){
    var srcUrl = this.get('settings').get('srcUrl');
    if(Ember.isBlank(srcUrl)){
      throw new Error("No src_url specified: specify a src_url in the url query params.");
    }

    var style = this.get('settings').get('style');
    if(style){
      Ember.$('head').append('<link href="' + style + '" media="all" rel="stylesheet">');
    }

  },

  model: function(params){
    var settings = this.get('settings');
    return new Ember.RSVP.Promise(function(resolve, reject){
      var url = settings.get('srcUrl');

      var assessment = Assessment.create({
        srcUrl: url,
        offline: settings.get('offline'),
        srcData: settings.get('srcData')
      });

      assessment.on('loaded', function(){
        // Record that the assessment was viewed
        AssessmentResult.create({
          offline: settings.get('offline'),
          assessment_id: settings.get('assessmentId'),
          identifier: assessment.get('id'),
          eId: settings.get('eId'),
          external_user_id: settings.get('externalUserId'),
          resultsEndPoint: settings.get('resultsEndPoint'),
          keywords: settings.get('keywords'),
          objectives: assessment.get('objectives'),
          src_url: url
        }).save().then(function(result) {
          assessment.set('assessment_result', result);
          resolve(assessment);
        }.bind(this), function(e) {
          console.log("Assessment error ======");
          console.log(e);
          resolve(assessment);
        }.bind(this));
      }.bind(this));

      assessment.on('error', function(){
        reject(new Error("Failed to load assessment"));
      });

      assessment.loadAndParse();

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
