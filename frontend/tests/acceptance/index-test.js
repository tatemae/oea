import startApp from '../helpers/start-app';
import XML from '../fixtures/8';
var ajax = require('ic-ajax');

window.OEA_SETTINGS = {
  qtiUrl: '/fixtures/8.xml',
  userId: '1',
  resultsEndPoint: '/api'
};

ajax.defineFixture('/fixtures/8.xml', {
  response: XML.xml,
  jqXHR: {},
  textStatus: 'success'
});

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
