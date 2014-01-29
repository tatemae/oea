Oea.ItemRoute = Ember.Route.extend({

  model: function(params){
    return this.modelFor('items').findBy('id', params.item_id);
  }

});
