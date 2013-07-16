ItemsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('section').items();
  },

  afterModel: function(items, transition){
    transition.abort();
    var item = items.get('firstObject');
    if(item){
      this.transitionTo('item', items.get('firstObject'));
    }
  }

});
module.exports = ItemsRoute;