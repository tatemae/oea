SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('assessment').sections();
  },

  afterModel: function(sections, transition){
    transition.abort();
    var section = sections.get('firstObject');
    if(section){
      this.transitionTo('section', sections.get('firstObject'));
    }
  }

});

module.exports = SectionsRoute;