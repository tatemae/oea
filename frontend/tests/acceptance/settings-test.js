import { test, moduleFor } from 'ember-qunit';
import Settings from '../../models/settings';

moduleFor("model:settings", "Unit - Settings", {
  setup: function () {
    window.OEA_SETTINGS = {
      qtiUrl: '/fixtures/8.xml',
      userId: '3',
      resultsEndPoint: '/api',
      assessmentId: 1
    };
  },
  teardown: function () {
    delete window.OEA_SETTINGS;
  }
});

test("it exists", function(){
  expect(2);

  var settings = this.subject();

  ok(settings);
  equal(settings.get("qtiUrl"), '/fixtures/8.xml');
});
