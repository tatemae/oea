var Assessment = require('../models/assessment');
AssessmentsRoute = Ember.Route.extend({
  model: function() {
    return Assessment.findAll();
  }
});

module.exports = AssessmentsRoute;
