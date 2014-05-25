import Qti from "../utils/qti";
import Utils from '../utils/utils';
import ItemResult from '../models/item_result';

export default Ember.ObjectController.extend({
  needs: "application",

  promptConfidenceLevel: function(){
    return this.get('settings').get('confidenceLevels');
  }.property(),

  actions: {
    checkAnswer: function(selectedConfidenceLevel){
      var xml = this.get('xml');
      var selectedAnswerId = this.get('selectedAnswerId');
      var score = 0; // TODO we should get var names and types from the QTI. For now we just use the default 'score'
      var feedbacks = Ember.A();

      $.each(xml.find('respcondition'), function(i, condition){

        condition = $(condition);
        var conditionMet = false;

        if(condition.find('conditionvar > varequal').length){
          var varequal = condition.find('conditionvar > varequal');
          if(varequal.text() === selectedAnswerId){
            conditionMet = true;
          }
        } else if(condition.find('conditionvar > unanswered').length){
          if(Ember.isEmpty(selectedAnswerId)){
            conditionMet = true;
          }
        } else if(condition.find('conditionvar > not').length){
          if(condition.find('conditionvar > not > varequal').length){
            if(selectedAnswerId !== condition.find('conditionvar > not > varequal').text()){
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
          if(action === 'Add'){
            score += parseFloat(setvar.text(), 10);
          } else if(action === 'Set'){
            score = parseFloat(setvar.text());
          }
          var feedbackId = condition.find('displayfeedback').attr('linkrefid');
          if(feedbackId){
            var feedback = xml.find('itemfeedback[ident="' + feedbackId + '"]');
            if(feedback && feedback.attr('view') && feedback.attr('view').length === 0 ||
              feedback.attr('view') === 'All' ||
              feedback.attr('view') === 'Candidate' ){  //All, Administrator, AdminAuthority, Assessor, Author, Candidate, InvigilatorProctor, Psychometrician, Scorer, Tutor
              var result = Qti.buildMaterial(feedback.find('material').children());
              if(feedbacks.indexOf(result) === -1){
                feedbacks.pushObject(result);
              }
            }
          }
        }

        if(condition.attr('continue') === 'No'){ return false; }
      });

      var start = this.get('start');
      if(!Ember.isNone(start)){
        var end = Utils.currentTime();
        ItemResult.create({
          assessment: this.get('controllers.application').get('model'),
          resultsEndPoint: this.get('settings').get('resultsEndPoint'),
          user_id: this.get('settings').get('userId'),
          item_id: this.get('id'),
          identifier: this.get('id'),
          session_status: 'final',
          time_spent: end - start,
          confidence_level: selectedConfidenceLevel
        }).save();
      }

      this.set('choiceFeeback', feedbacks);
      this.set('result', (score > 0) ? 'Correct!' : 'Incorrect!');
    }
  },

  isMultipleChoice: function(){
    return this.get('question_type') === 'multiple_choice_question';
  }.property('question_type')

});
