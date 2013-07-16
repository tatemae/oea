var Assessment = require('../models/assessment');
AssessmentsRoute = Ember.Route.extend({
  model: function() {
    return Assessment.all();
  }
});

module.exports = AssessmentsRoute;
