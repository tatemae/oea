var Assessment = require('../models/assessment');
var IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('assessments');
  }
});

module.exports = IndexRoute;