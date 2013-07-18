ItemsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('section').items();
  },

  setupController: function(controller, model){
    this.transitionTo('item', model[0]);
  }

});
module.exports = ItemsRoute;