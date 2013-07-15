var App = require('./app');

App.Router.map(function(){
  this.resource('assessments', function() {
    this.route('new');
    this.route('show');
  });
});
