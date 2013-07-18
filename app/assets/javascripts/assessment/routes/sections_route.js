SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('assessment').sections();
  },

  setupController: function(controller, model){
    //this.transitionTo('show', model[0]);
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'sections.index'){
      this.transitionTo('section', model[0]);
    }
  }

});

module.exports = SectionsRoute;