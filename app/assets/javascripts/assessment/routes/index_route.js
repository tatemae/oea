var Assessment = require('../models/assessment');
var IndexRoute = Ember.Route.extend({

  model: function() {
    return Assessment.find(global_assessment_id);
  }

});

module.exports = IndexRoute;