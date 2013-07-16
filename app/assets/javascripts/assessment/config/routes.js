var App = require('./app');

App.Router.map(function(){
  this.resource('assessments');
  this.resource('assessment', { path:  '/assessment/:assessment_id' }, function(){
    this.resource('sections', function(){
      this.resource('section', { path: '/:section_id' }, function(){
        this.resource('items', function(){
          this.resource('item');
        });
      });
    });
  });
});