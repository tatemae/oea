import Ember from 'ember';
import startApp from '../helpers/start-app';

var App;

module('Integration - Keywords', {
  setup: function() {
    window.OEA_SETTINGS = {
      qtiUrl: '/assessment.xml',
      userId: '2',
      resultsEndPoint: '/api',
      assessmentId: 1,
    };
    App = startApp();
  },
  teardown: function() {
    Ember.run(App, 'destroy'); //comment this out to see the app in the state once the test it finished
    delete window.OEA_SETTINGS;
  }
});

test('objectives are parsed', function(){
  expect(1);
  visit('/');
  andThen(function(){
    //the objectives are in the assessment.xml file
    var objectives = ["learning_objective_id_or_url_for_the_assessment", "another_learning_objective_id_or_url_for_the_assessment"];
    var assessment = App.__container__.lookup('controller:application').get('content');
    deepEqual(assessment.get("objectives"), objectives);
  });
});
