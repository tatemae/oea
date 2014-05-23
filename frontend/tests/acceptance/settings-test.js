import { test, moduleFor } from 'ember-qunit';
import Settings from '../../models/settings';

window.OEA_SETTINGS = {
  qtiUrl: '/fixtures/8.xml',
  userId: '1',
  resultsEndPoint: '/api'
};

moduleFor("model:settings", "Unit - Settings", {
  setup: function () {},
  teardown: function () {}
});

test("it exists", function(){
  expect(2);

  ok(Settings);
  equal(Settings.get("qtiUrl"), '/fixtures/8.xml');
});