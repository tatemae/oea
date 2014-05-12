import startApp from '../helpers/start-app';

window.OEA_SETTINGS = {
  qtiUrl: 'http://localhost:4200/fixtures/8.xml',
  userId: '1',
  resultsEndPoint: 'http://localhost:4200/api'
};

var App;

module('Integration - Index', {
  setup: function() {
    App = startApp();
  },
  teardown: function() {
    Ember.run(App, 'destroy'); //comment this out to see the app in the state once the test it finished
  }
});

test('index transitions to question', function(){
  visit('/');
  andThen(function(){
    equal(find('div.header p').text(), 'Question 1');
  });
});

test('when a question is viewed a result is created', function(){
  visit('/');
  andThen(function(){
    debugger;
    equal(this.store.find('item_result'));
  });
});
