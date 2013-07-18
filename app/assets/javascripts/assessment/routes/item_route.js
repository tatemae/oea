var Item = require('../models/item');
ItemRoute = Ember.Route.extend({

  model: function(params){
    return Item.find(this.modelFor('section').items(), params.item_id);
  }

});

module.exports = ItemRoute;