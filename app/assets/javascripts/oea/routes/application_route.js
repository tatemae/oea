Oea.ApplicationRoute = Ember.Route.extend({

  model: function(params){
    return new Promise(function(resolve, reject){

      var assessment = Oea.Assessment.create({
        qtiUrl: OEA_SETTINGS.qtiUrl
      });

      assessment.on('loaded', function(){
        resolve(assessment);
      }.bind(this));

      assessment.on('error', function(){
        reject(new Error("Failed to load assessment"));
      });
    });
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'index'){
      this.transitionTo('sections');
    }
  }

});



