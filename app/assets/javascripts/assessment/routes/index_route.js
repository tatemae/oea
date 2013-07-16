var IndexRoute = Ember.Route.extend({
  beforeModel: function(){
    this.transitionTo('assessments');
  }
});

module.exports = IndexRoute;