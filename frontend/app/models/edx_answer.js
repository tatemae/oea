import Ember from 'ember';
import Base from "./base";
import EdX from "../utils/edx";

var EdxAnswer = Base.extend({
  score: 0,
  feedbacks: null
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