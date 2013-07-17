ItemRoute = Ember.Route.extend({

  model: function(params){
    // var items = this.modelFor('items');
    // return items.find(function(item, index, enumerable){
    //   if(item.id == params.id){
    //     return item;
    //   }
    // });
  }

});

module.exports = ItemRoute;