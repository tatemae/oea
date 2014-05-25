import Settings from '../models/settings';

export default {
  name: "settings",
  initialize: function( container, application ) {
    application.register( 'model:settings', Settings );
    application.inject('controller', 'settings', 'model:settings');
    application.inject('route', 'settings', 'model:settings');
  }
};
