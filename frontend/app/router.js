var Router = Ember.Router.extend({
  rootURL: ENV.rootURL,
  location: 'history'
});

Router.map(function() {
  this.resource('sections',                                            function(){
    this.resource('section',  { path: '/:section_id' },                function(){
      this.resource('items',                                           function(){
        this.resource('item', { path: '/:item_id' });
      });
    });
  });
});

export default Router;
