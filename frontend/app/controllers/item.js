import Ember from 'ember';
import Qti from "../utils/qti";
import Utils from '../utils/utils';
import ItemResult from '../models/item_result';

export default Ember.ObjectController.extend({
  needs: "application",

  promptConfidenceLevel: function(){
    return this.get('settings').get('confidenceLevels');
  }.property(),

  didFindModel: function(){
    return !Ember.isNone(this.get('model'));
  }.property(),

  actions: {
    checkAnswer: function(selectedConfidenceLevel){
      var results;
      switch(this.get('question_type')){
        case 'multiple_choice_question':
          results = this.checkMultipleChoiceAnswer();
          break;
        case 'edx_drag_and_drop':
          results = this.checkEdXDragAndDrop();
          break;
        case 'edx_numerical_input':
          results = this.checkEdXNumeric();
          break;
        case 'edx_multiple_choice':
          results = this.checkEdXMultipleChoice();
          break;
      }

      var start = this.get('start');
      if(!Ember.isNone(start)){
        var end = Utils.currentTime();
        var settings = this.get('settings');
        ItemResult.create({
          offline: settings.get('offline'),
          assessment_result_id: this.get('controllers.application').get('model').get('assessment_result.id'),
          resultsEndPoint: settings.get('resultsEndPoint'),
          eId: settings.get('eId'),
          external_user_id: settings.get('externalUserId'),
          keywords: settings.get('keywords'),
          objectives: this.get('controllers.application').get('model').get('objectives').concat(this.get('model').get('objectives')),
          src_url: settings.get('srcUrl'),
          identifier: this.get('id'),
          session_status: 'final',
          time_spent: end - start,
          confidence_level: selectedConfidenceLevel,
          correct: results.correct,
          score: results.score
        }).save();
      }

      this.set('choiceFeeback', results.feedbacks);
      this.set('result', results.correct ? 'Correct!' : 'Incorrect!');
    }
  },

  checkMultipleChoiceAnswer: function(){
    var xml = this.get('xml');
    var selectedAnswerId = this.get('selectedAnswerId');
    var score = 0; // TODO we should get var names and types from the QTI. For now we just use the default 'score'
    var feedbacks = Ember.A();
    var correct = false;

    Ember.$.each(xml.find('respcondition'), function(i, condition){

      condition = Ember.$(condition);
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
        if(setvar.length > 0){
          var setvarVal = parseFloat(setvar.text(), 10);
          if(setvarVal > 0){
            correct = true;
            var action = setvar.attr('action');
            if(action === 'Add'){
              score += setvarVal;
            } else if(action === 'Set'){
              score = setvarVal;
            }
          }
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

    return {
      feedbacks: feedbacks,
      score: score,
      correct: correct
    };

  },

  checkEdXDragAndDrop: function(){
    return this.checkEdX();
  },

  checkEdXNumeric: function(){
    return this.checkEdX();
  },

  checkEdXMultipleChoice: function(){
    return this.checkEdX();
  },

  checkEdX: function(){
    var result = {
      feedbacks: Ember.A(),
      score: 0,
      correct: true
    };
    this.get('answers').forEach(function(answer){
      if(answer.get('graded')){
        answer.set('isGraded', false);
        Ember.$.each(answer.get('graded'), function(id, graded){
          if(graded.feedback && graded.feedback.length > 0){
            result.feedbacks.push(graded.feedback);
          }
          result.score += graded.score;
          if(!graded.correct){
            result.correct = false;
          }
        });
        answer.set('isGraded', true);
      } else {
        result.correct = false;
      }
    });
    return result;
  },

  isMultipleChoice: function(){
    return this.get('question_type') === 'multiple_choice_question';
  }.property('question_type'),

  isDragAndDrop: function(){
    return this.get('question_type') === 'drag_and_drop';
  }.property('question_type'),

  isEdXDragAndDrop: function(){
    return this.get('question_type') === 'edx_drag_and_drop';
  }.property('question_type'),

  isEdXNumericalInput: function(){
    return this.get('question_type') === 'edx_numerical_input';
  }.property('question_type'),

  isEdXTextInput: function(){
    return this.get('question_type') === 'edx_text_input';
  }.property('question_type'),

  isEdXDropdown: function(){
    return this.get('question_type') === 'edx_dropdown';
  }.property('question_type'),

  isEdXMultipleChoice: function(){
    return this.get('question_type') === 'edx_multiple_choice';
  }.property('question_type')

});
