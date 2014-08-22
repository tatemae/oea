import Ember from 'ember';
import Base from "./base";
import EdX from "../utils/edx";

var EdxAnswer = Base.extend({

  question: function(){
    return EdX.buildProblemMaterial(this.get('xml'));
  }.property('xml'),

  images: function(){
    var imgs = Ember.A();
    var dndRoot = this.get('xml').find('drag_and_drop_input');
    if(dndRoot.length > 0){
      var image = {
        src: dndRoot.attr('img'),
        title: 'Drag and Drop main image'
      };
      imgs.pushObject(image);
    }
    return imgs;
  }.property('xml'),

  draggables: function(){
    return Ember.$.map(this.get('xml').find('draggable'), function(draggable){
      draggable = Ember.$(draggable);
      return {
        'id': draggable.attr('id'),
        'label': draggable.attr('label')
      };
    });
  }.property('xml'),

  correctAnswer: function(){
    var answer = this.get('xml').find('answer').html();
    answer = answer.replace('correct_answer =', '');
    answer = answer.substring(0, answer.indexOf('if draganddrop.grade'));
    return eval(answer);
  }

});

EdxAnswer.reopenClass({

  fromEdX: function(id, xml){
    xml = Ember.$(xml);
    return EdxAnswer.create({
      'id': id,
      'xml': xml
    });
  },

  parseAnswers: function(xml){
    return EdX.answersFromProblem(xml, EdxAnswer);
  }

});

export default EdxAnswer;