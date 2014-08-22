import Ember from 'ember';
import Utils from './utils';

var EdX = {

  // ////////////////////////////////////////////////////
  // Problem (Item) functionality
  //
  buildProblemMaterial: function(xml){
    var contents = Ember.$('<div>').append(xml.html());
    contents.find('solution').remove();
    contents.find('stringresponse').remove();
    contents.find('customresponse').remove();
    contents.find('draggable').remove();
    contents.find('answer').remove();
    contents.find('drag_and_drop_input').remove();
    return contents.html();
  },

  answersFromProblem: function(xml, klass, question_type){
    var list = Ember.A();
    var responses = xml.find('customresponse');
    if(responses.length > 0){
      Ember.$.each(xml.find('customresponse'), function(i, x){
        list.pushObject(klass.fromEdX(Utils.makeId(), x, question_type));
      });
    } else {
      list.pushObject(klass.fromEdX(Utils.makeId(), xml, question_type));
    }
    return list;
  },

  questionType: function(xml){
    if(xml.find('drag_and_drop_input').length > 0){
      return 'edx_drag_and_drop';
    }
  }

};

export default EdX;