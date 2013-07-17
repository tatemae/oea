SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('assessment').sections();
  },

  afterModel: function(sections, transition){
    this.transitionTo('/section/' + sections[0].id);
  }

});

module.exports = SectionsRoute;