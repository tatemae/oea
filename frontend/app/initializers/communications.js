import CommunicationHandler from '../utils/communication_handler';

export default {
  name: "communications",
  initialize: function( container, application ) {
    CommunicationHandler.init();
  }
};