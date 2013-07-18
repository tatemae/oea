SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('assessment').sections();
  },

  setupController: function(controller, model){
    this.transitionTo('section', model[0]);
  }

});

module.exports = SectionsRoute;