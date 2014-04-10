export default SectionRoute = Ember.Route.extend({

  model: function(params){
    return this.modelFor('sections').findBy('id', params.section_id);
  },

  afterModel: function(model, transition){
    if(transition.targetName == 'section.index'){
      this.transitionTo('items');
    }
  }

});
