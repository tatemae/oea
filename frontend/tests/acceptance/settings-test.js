import { test, moduleFor } from 'ember-qunit';

window.OEA_SETTINGS = {
  qtiUrl: '/fixtures/8.xml',
  userId: '1',
  resultsEndPoint: '/api'
};

console.log(window.location);

moduleFor("model:settings", "Unit - Settings", {
  setup: function () {},
  teardown: function () {}
});

test("it exists", function(){
  expect(2);

  var settings = this.subject();

  ok(settings);
  equal(settings.get("qtiUrl"), '/fixtures/8.xml');
});
