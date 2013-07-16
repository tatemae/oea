var App = require('./app');

App.Router.map(function(){
  this.resource('assessments');
  this.resource('assessment', { path: '/assessment/:assessment_id' }, function(){
    this.resource('questions');
  });
});