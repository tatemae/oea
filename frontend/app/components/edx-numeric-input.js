import Ember from 'ember';
import EdX from "../utils/edx";
import EdXBase from './edx-base';

export default EdXBase.extend({

  graded: {},
  inputPrefix: 'numeric_question_',

  keyUp: function(e){
    var args = {
      id: e.target.id.replace(this.inputPrefix, ''),
      value: parseFloat(e.target.value, 10)
    };
    Ember.run.debounce(this, this.checkAnswers, args, 300);
  },

  title: function(){
    return this.get('content.xml').attr('display_name');
  }.property('content.xml'),

  question: function(){
    var inputs = {};
    var contents = Ember.$('<div>').append(this.get('content.xml').html());
    contents.find('solution').remove();

    contents.find('numericalresponse').each(function(i, numericalresponse){
      numericalresponse = Ember.$(numericalresponse);
      inputs[i] = numericalresponse;
      var input = Ember.$('<input/>').attr('id', this.inputPrefix + i).attr('type', 'text');
      numericalresponse.replaceWith(input);
    }.bind(this));

    this.set('inputs', inputs);

    return contents.html();

  }.property('content.xml'),

  solution: function(){
    return this.get('content.xml').find('solution').html();
  }.property('content.xml'),

  checkAnswers: function(args){
    var correct = false;
    var score = 0;
    var graded = this.get('graded');
    var numericalResponse = this.get('inputs')[args.id];
    var answer = parseFloat(numericalResponse.attr('answer'), 10);
    var tolerance = numericalResponse.find('[type="tolerance"]').attr('default');
    if(tolerance){
      if(tolerance.indexOf('%') >= 0){
        tolerance = tolerance.replace('%', '');
        tolerance = parseFloat(tolerance);
        tolerance = tolerance * 0.01;
      } else {
        tolerance = parseFloat(tolerance);
      }
      var deviation = answer*tolerance;
      correct = (args.value > answer - deviation) && (args.value < answer + deviation);
    } else {
      correct = args.value == answer;
    }
    if(correct){
      score = 1;
    }
    graded[args.id] = {
      correct: correct,
      feedback: '',
      score: score
    };

    this.get('content').set('graded', graded);
  },

  isGradedDidChange: function(){
    this.get('content.graded').each(function(i, numericalresponse){
      // highlight incorrect answers
    });

  }.observes('content.isGraded')

});

// Example xml for Numerical Input

// <problem display_name="Numerical Input" markdown="A numerical input problem accepts a line of text input from the student, and evaluates the input for correctness based on its numerical value.&#10;&#10;The answer is correct if it is within a specified numerical tolerance of the expected answer.&#10;&#10;&gt;&gt;Enter the numerical value of Pi:&lt;&lt;&#10;= 3.14159 +- .02&#10;&#10;&gt;&gt;Enter the approximate value of 502*9:&lt;&lt;&#10;= 4518 +- 15%&#10;&#10;&gt;&gt;Enter the number of fingers on a human hand&lt;&lt;&#10;= 5&#10;&#10;[explanation]&#10;Pi, or the the ratio between a circle's circumference to its diameter, is an irrational number known to extreme precision. It is value is approximately equal to 3.14.&#10;&#10;Although you can get an exact value by typing 502*9 into a calculator, the result will be close to 500*10, or 5,000. The grader accepts any response within 15% of the true value, 4518, so that you can use any estimation technique that you like.&#10;&#10;If you look at your hand, you can count that you have five fingers.&#10;[explanation]&#10;">
//   <p>
// A numerical input problem accepts a line of text input from the
// student, and evaluates the input for correctness based on its
// numerical value.
// </p>
//   <p>
// The answer is correct if it is within a specified numerical tolerance
// of the expected answer.
// </p>
//   <script type="loncapa/python">
// computed_response = 502*9
// </script>
//   <p>Enter the numerical value of Pi:
//     <numericalresponse answer="3.14159">
//       <responseparam type="tolerance" default=".02"/>
//       <formulaequationinput label="Enter the numerical value of Pi"/>
//     </numericalresponse>
// </p>
//   <p>Enter the approximate value of 502*9:
//     <numericalresponse answer="$computed_response"><responseparam type="tolerance" default="15%"/><formulaequationinput label="Enter the approximate value of 502 times 9"/></numericalresponse>
// </p>
//   <p>Enter the number of fingers on a human hand:
//     <numericalresponse answer="5"><formulaequationinput label="Enter the number of fingers on a human hand"/></numericalresponse>
// </p>
//   <solution>
//     <div class="detailed-solution">
//       <p>Explanation</p>
//       <p>Pi, or the the ratio between a circle's circumference to its diameter, is an irrational number known to extreme precision. It is value is approximately equal to 3.14.</p>
//       <p>Although you can get an exact value by typing 502*9 into a calculator, the result will be close to 500*10, or 5,000. The grader accepts any response within 15% of the true value, 4518, so that you can use any estimation technique that you like.</p>
//       <p>If you look at your hand, you can count that you have five fingers.</p>
//     </div>
//   </solution>
// </problem>
