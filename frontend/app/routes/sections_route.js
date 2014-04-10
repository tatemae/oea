export default SectionsRoute = Ember.Route.extend({

  model: function() {
    return this.modelFor('application').get('sections');
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'sections.index'){
      this.transitionTo('section', model.objectAt(0));
    }
  }

});
