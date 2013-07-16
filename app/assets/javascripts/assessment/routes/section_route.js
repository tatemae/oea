SectionRoute = Ember.Route.extend({

  model: function(params){
    return this.modelFor('assessment').sections();
  },

  afterModel: function(section, transition) {
    this.transitionTo('items');
  }

});

module.exports = SectionRoute;