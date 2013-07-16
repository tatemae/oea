var Assessment = require('../models/assessment');
SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('assessment').sections();
  },

  afterModel: function(sections, transition){
    var section = sections.get('firstObject');
    if(section){
      this.transitionTo('sections', sections.get('firstObject'));
    }
  }

});

module.exports = SectionsRoute;