ItemsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('section').items();
  },

  afterModel: function(items, transition){
    this.transitionTo('/item/' + items[0].id);
  }

});
module.exports = ItemsRoute;