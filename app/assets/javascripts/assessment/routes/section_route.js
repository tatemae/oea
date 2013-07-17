SectionRoute = Ember.Route.extend({

  model: function(params){
    return new Ember.RSVP.Promise(function(resolve, reject){
      var sections = this.modelFor('sections');
      return sections.find(function(item, index, enumerable){
        if(item.id == params.section_id){
          return resolve(item);
        }
      });
    });
  },

  afterModel: function(section, transition){
    this.transitionTo('items');
  }

});

module.exports = SectionRoute;