var Item = require('../models/item');
var IndexRoute = Ember.Route.extend({

  model: function() {
    return Item.find();
  }

});

module.exports = IndexRoute;

