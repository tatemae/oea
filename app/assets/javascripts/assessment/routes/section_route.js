SectionRoute = Ember.Route.extend({

  model: function(params){
    var sections = this.modelFor('sections').sections();
    return sections.find(function(item, index, enumerable){
      if(item.id == params.id){
        return item;
      }
    });
  },

  afterModel: function(section, transition){
    transition.abort();
    this.transitionTo('items');
  }

});

module.exports = SectionRoute;