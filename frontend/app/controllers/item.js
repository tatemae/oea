import Ember from 'ember';
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
      var results;
      switch(this.get('question_type')){
        case 'multiple_choice_question':
          results = this.checkMultipleChoiceAnswer();
          break;
        case 'edx_drag_and_drop':
          results = this.checkEdXDragAndDrop();
          break;
      }

      var start = this.get('start');
      if(!Ember.isNone(start)){
        var end = Utils.currentTime();
        var settings = this.get('settings');
        ItemResult.create({
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
          confidence_level: selectedConfidenceLevel
        }).save();
      }

      this.set('choiceFeeback', results.feedbacks);
      this.set('result', (results.score > 0) ? 'Correct!' : 'Incorrect!');
    }
  },

  checkMultipleChoiceAnswer: function(){
    var xml = this.get('xml');
    var selectedAnswerId = this.get('selectedAnswerId');
    var score = 0; // TODO we should get var names and types from the QTI. For now we just use the default 'score'
    var feedbacks = Ember.A();

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

    return {
      feedbacks: feedbacks,
      score: score
    };

  },

  checkEdXDragAndDrop: function(){
    var score = 0;
    this.get('answers').forEach(function(answer){
      graded += answer.get('graded');
    });
    var feedbacks = [];
    return {
      feedbacks: feedbacks,
      score: score
    };
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

  isEdXDropdown: function(){
    return this.get('question_type') === 'edx_dropdown';
  }.property('question_type'),

  isEdXMultipleChoice: function(){
    return this.get('question_type') === 'edx_multiple_choice';
  }.property('question_type')

});
