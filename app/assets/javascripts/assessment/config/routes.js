var App = require('./app');

App.Router.map(function(){
  this.route('assessments');
  this.route('assessment', { path:  '/assessment/:assessment_id' });
  this.route('sections', { path: '/assessment/:assessment_id/sections' });
  this.route('section', { path: '/assessment/:assessment_id/sections/:section_id' });
  this.route('items', { path: '/assessment/:assessment_id/sections/:section_id/items' });
  this.route('item', { path: '/assessment/:assessment_id/sections/:section_id/items/:item_id' });

  // this.resource('assessments');
  // this.resource('assessment', { path:  '/assessment/:assessment_id' }, function(){
  //   this.resource('sections', function(){
  //     this.resource('section', { path: '/:section_id' }, function(){
  //       this.resource('items', function(){
  //         this.resource('item');
  //       });
  //     });
  //   });
  // });

});