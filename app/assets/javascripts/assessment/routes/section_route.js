var Section = require('../models/section');
SectionRoute = Ember.Route.extend({

  model: function(params){
    return Section.find(this.modelFor('assessment').sections(), params.section_id);
  },

  setupController: function(controller, model){
    this.transitionTo('items');
  }

});

module.exports = SectionRoute;