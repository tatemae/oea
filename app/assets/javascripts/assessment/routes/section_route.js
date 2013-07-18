var Section = require('../models/section');
SectionRoute = Ember.Route.extend({

  model: function(params){
    return Section.find(this.modelFor('assessment').sections(), params.section_id);
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'section.index'){
      this.transitionTo('items');
    }
  }

});

module.exports = SectionRoute;