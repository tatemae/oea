import Ember from 'ember';
import Base from "./base";
import EdX from "../utils/edx";

var EdxAnswer = Base.extend({

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