import Ember from 'ember';
import EdX from "../utils/edx";
import EdXBase from './edx-base';

export default EdXBase.extend({

  choicePrefix: 'choice_',

  didInsertElement: function(){
    this.set('graded', {});
    this._super();
  },

  click: function(e){
    var radio = $(e.target);
    if(!radio.is('[type="radio"]')){
      radio = radio.find('[type="radio"]');
    }
    if(radio.length > 0){
      var args = {
        id: radio.attr('id').replace(this.choicePrefix, '')
      };
      Ember.run.debounce(this, this.checkAnswers, args, 300);
    }
  },

  title: function(){
    return this.get('content.xml').attr('display_name');
  }.property('content.xml'),

  question: function(){
    var choices = this.get('choices') || {};
    var contents = Ember.$('<div>').append(this.get('content.xml').html());
    contents.find('solution').remove();

    contents.find('multiplechoiceresponse').each(function(i, response){
      var html = '';
      response = Ember.$(response);
      response.find('choicegroup').each(function(j, group){
        group = Ember.$(group);
        var groupName = "";
        group.find('choice').each(function(k, choice){
          var groupName = 'group_' + i + '_' + j;
          choice = Ember.$(choice);
          var id = i + '_' + j + '_' + k;
          choices[id] = {
            correct: choice.attr('correct')
          }
          html += '<div class="btn btn-block btn-question"><label class="radio"><input id="' + this.choicePrefix + id + '" type="radio" name="' + groupName + '" value="' + choice.attr('name') + '">' + choice.html() + '</label></div>';
        }.bind(this));
      }.bind(this));
      html = '<div class="multiple-choice-question">' + html + '</div>';
      response.replaceWith(html);
    }.bind(this));
    this.set('choices', choices);
    return contents.html();
  }.property('content.xml'),

  solution: function(){
    return this.get('content.xml').find('solution').html();
  }.property('content.xml'),

  checkAnswers: function(args){
    var graded = this.get('graded') || {};
    var choice = this.get('choices')[args.id];
    if(choice && choice.correct == 'true'){
      graded[args.id] = {
        correct: true,
        feedback: '',
        score: 1
      };
    } else {
      graded[args.id] = {
        correct: false,
        feedback: '',
        score: 0
      };
    }

    this.get('content').set('graded', graded);
  },

  isGradedDidChange: function(){
    this.$('.incorrect').removeClass('incorrect');
    var graded = this.get('content.graded');
    Ember.$.each(graded, function(i, graded){
      if(!graded.correct){
        this.$('#' + this.choicePrefix + i).parents('.btn-question').addClass('incorrect');
      }
    }.bind(this));

  }.observes('content.isGraded')

});

// Example xml for Multiple Choice

// <problem display_name="Multiple Choice" markdown="A multiple choice problem presents radio buttons for student input. Students can only select a single option presented. Multiple Choice questions have been the subject of many areas of research due to the early invention and adoption of bubble sheets.&#10;&#10;One of the main elements that goes into a good multiple choice question is the existence of good distractors. That is, each of the alternate responses presented to the student should be the result of a plausible mistake that a student might make.&#10;&#10;&gt;&gt;What Apple device competed with the portable CD player?&lt;&lt;&#10;     ( ) The iPad&#10;     ( ) Napster&#10;     (x) The iPod&#10;     ( ) The vegetable peeler&#10;     &#10;[explanation]&#10;The release of the iPod allowed consumers to carry their entire music library with them in a format that did not rely on fragile and energy-intensive spinning disks.&#10;[explanation]&#10;">
//   <p>
// A multiple choice problem presents radio buttons for student
// input. Students can only select a single option presented. Multiple Choice questions have been the subject of many areas of research due to the early invention and adoption of bubble sheets.</p>
//   <p> One of the main elements that goes into a good multiple choice question is the existence of good distractors. That is, each of the alternate responses presented to the student should be the result of a plausible mistake that a student might make. 
// </p>
//   <p>What Apple device competed with the portable CD player?</p>
//   <multiplechoiceresponse>
//     <choicegroup type="MultipleChoice" label="What Apple device competed with the portable CD player?">
//       <choice correct="false" name="ipad">The iPad</choice>
//       <choice correct="false" name="beatles">Napster</choice>
//       <choice correct="true" name="ipod">The iPod</choice>
//       <choice correct="false" name="peeler">The vegetable peeler</choice>
//     </choicegroup>
//   </multiplechoiceresponse>
//   <solution>
//     <div class="detailed-solution">
//       <p>Explanation</p>
//       <p>The release of the iPod allowed consumers to carry their entire music library with them in a format that did not rely on fragile and energy-intensive spinning disks. </p>
//     </div>
//   </solution>
// </problem>
