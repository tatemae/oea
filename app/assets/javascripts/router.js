Oea.Router.map(function() {
  this.resource('assessments', function() {
    this.resource('assessment', { path: ':assessment_id' })
  });
});