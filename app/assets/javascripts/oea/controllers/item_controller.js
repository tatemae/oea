Oea.ItemController = Ember.ObjectController.extend({

  selectedAnswer: null,
  checkAnswerResult: null,

  actions: {
    checkAnswer: function(){
      this.set('checkAnswerResult', 'You selected ' + this.get('selectedAnswer.text'));
    }
  },

  isMultipleChoice: function(){
    return this.get('question_type') == 'multiple_choice_question';
  }

});
