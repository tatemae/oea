import Ember from 'ember';
export default Ember.Route.extend({

  model: function() {
    return this.modelFor('section').get('items');
  },

  afterModel: function(model, transition){
    if(transition.targetName === 'items.index'){
      this.transitionTo('item', model.objectAt(0));
    }
  }

});
