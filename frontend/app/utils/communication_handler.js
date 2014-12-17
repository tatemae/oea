import Ember from 'ember';
import Communicator from '../utils/communicator';

export default {

  init: function(){
    Communicator.enableListener(this);
  },

  sendSize: function(){
    var payload = {
      height: Ember.$(document).height(),
      width: Ember.$(document).width()
    };
    Communicator.commMsg('open_assessments_resize', payload);
  },

  handleComm: function(e){
    switch(e.data.open_assessments_msg){
      case 'open_assessments_size_request':
        this.sendSize();
        break;
    }
  }

};
