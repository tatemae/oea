ItemsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('section').items();
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'items.index'){
      this.transitionTo('item', model[0]);
    }
  }

});
module.exports = ItemsRoute;