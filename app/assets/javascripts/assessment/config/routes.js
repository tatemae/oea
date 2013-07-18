var App = require('./app');

App.Router.map(function(){

  this.resource('assessments');
  this.resource('assessment',   { path: '/assessment/:assessment_id' }, function(){
    this.resource('sections');
    this.resource('section',    { path: '/section/:section_id' },       function(){
      this.resource('items');
      this.resource('item',     { path: '/item/:item_id' });
    });
  });

});
