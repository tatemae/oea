//= require ./app
window.ENV = {"baseURL":"/","locationType":"none","FEATURES":{},"APP":{"LOG_RESOLVER":true,"LOG_ACTIVE_GENERATION":true,"LOG_MODULE_RESOLVER":true,"LOG_TRANSITIONS":true,"LOG_VIEW_LOOKUPS":true,"LOG_STACKTRACE_ON_DEPRECATION":true,"LOG_BINDINGS":true},"LOG_MODULE_RESOLVER":true};
window.Oea = require('oea/app')['default'].create(ENV.APP);
