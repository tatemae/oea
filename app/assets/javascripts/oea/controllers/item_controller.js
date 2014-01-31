Oea.ItemController = Ember.ObjectController.extend({

  selectedAnswerId: null,
  checkAnswerResult: null,
  answerFeedback: Ember.ArrayProxy.create(),
  setValues: {},

  actions: {
    checkAnswer: function(){
      var xml = this.get('xml');
      var selectedAnswerId = this.get('selectedAnswerId');
      var score;
      var correct = false;
      $.each(xml.find('respcondition'), function(i, condition){

        condition = $(condition);
        conditionMet = false;

        if(condition.find('conditionvar > varequal').length){
          var varequal = condition.find('conditionvar > varequal');
          if(varequal.text() == selectedAnswerId){
            conditionMet = true;
            correct = true;
            //setValues
          }
        } else if(condition.find('conditionvar > unanswered').length){
          if(Ember.isEmpty(selectedAnswerId)){
            conditionMet = true;
          }
        } else if(condition.find('conditionvar > not').length){
          if(condition.find('conditionvar > not > varequal').length){
            if(selectedAnswerId == condition.find('conditionvar > not > varequal').text()){
              conditionMet = true;
            }
          } else if(condition.find('conditionvar > not > unanswered').length) {
            if(!Ember.isEmpty(selectedAnswerId)){
              conditionMet = true;
            }
          }

        }

        if(conditionMet){
          var setvar = condition.find('setvar');
          var action = setvar.attr('action');
          if(action == 'Add'){
            score += setvar.text();
          } else if(action == 'Set'){
            score = setvar.text();
          }
          var feedbackId = condition.find('displayfeedback').attr('linkrefid');
          if(feedbackId){
            var feedback = xml.find('itemfeedback[ident="' + feedbackId + '"]');
            if(feedback && feedback.attr('view').length === 0 ||
              feedback.attr('view') == 'All' ||
              feedback.attr('view') == 'Candidate' ){  //All, Administrator, AdminAuthority, Assessor, Author, Candidate, InvigilatorProctor, Psychometrician, Scorer, Tutor
              $.each(feedback.find('material').children(), function(i, child){
                answerFeedback.addObject($(child).html());
              });
            }
          }
        }

        if(condition.attr('continue') == 'No'){ return false; }
      });

      this.set('checkAnswerResult', correct ? 'Correct!' : 'Incorrect!');
    }
  },

  isMultipleChoice: function(){
    return this.get('question_type') == 'multiple_choice_question';
  }.property('question_type')

});
