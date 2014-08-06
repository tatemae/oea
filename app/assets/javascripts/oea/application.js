//= require ./vendor
//= require ./oea

window.OeaENV = {
  baseURL: '/',
  locationType: 'auto',
  EmberENV: {
    FEATURES: {
      // Here you can enable experimental features on an ember canary build
      // e.g. 'with-controller': true
    }
  },

  APP: {
    LOG_RESOLVER:true,
    LOG_ACTIVE_GENERATION:true,
    LOG_MODULE_RESOLVER:true,
    LOG_TRANSITIONS:true,
    LOG_VIEW_LOOKUPS:true,
    LOG_STACKTRACE_ON_DEPRECATION:true,
    LOG_BINDINGS:true
  }
};

window.EmberENV = window.OeaENV.EmberENV;
window.Oea = require('oea/app')['default'].create(OeaENV.APP);

