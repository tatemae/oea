import Ember from 'ember';
import Base from "./base";
import EdX from "../utils/edx";

var EdxAnswer = Base.extend({

  imageUrl: function(){
    var dndRoot = this.get('xml').find('drag_and_drop_input');
    if(dndRoot.length > 0){
      return dndRoot.attr('img');
    }
  }.property('xml'),

  imageTitle: function(){
    return 'Drag and Drop main image';
  }.property('xml'),

  draggables: function(){
    return Ember.$.map(this.get('xml').find('draggable'), function(draggable){
      draggable = Ember.$(draggable);
      return {
        'id': draggable.attr('id'),
        'label': draggable.attr('label')
      };
    });
  }.property('xml')

});

EdxAnswer.reopenClass({

  fromEdX: function(id, xml, question_type){
    xml = Ember.$(xml);
    return EdxAnswer.create({
      'id': id,
      'question_type': question_type,
      'xml': xml
    });
  },

  parseAnswers: function(xml, question_type){
    return EdX.answersFromProblem(xml, EdxAnswer, question_type);
  }

});

export default EdxAnswer;


//     <drag_and_drop_input img="https://studio.edx.org/c4x/edX/DemoX/asset/L9_buckets.png">
//       
//  <draggable id="1" label="a"/>
//  <draggable id="2" label="cat"/>
//  <draggable id="3" label="there"/>
//  <draggable id="4" label="pear"/>
//  <draggable id="5" label="kitty"/>
//  <draggable id="6" label="in"/>
//  <draggable id="7" label="them"/>
//  <draggable id="8" label="za"/>
//  <draggable id="9" label="dog"/>
//  <draggable id="10" label="slate"/>
//  <draggable id="11" label="few"/></drag_and_drop_input><answer type="loncapa/python">
// correct_answer = {
//         '1':      [[70, 150], 121],
//         '6':      [[190, 150], 121],
//         '8':      [[190, 150], 121],
//         '2':      [[310, 150], 121],
//         '9':      [[310, 150], 121],
//         '11':     [[310, 150], 121],
//         '4':      [[420, 150], 121],
//         '7':      [[420, 150], 121],
//         '3':      [[550, 150], 121],
//         '5':      [[550, 150], 121],
//         '10':     [[550, 150], 121]}
// if draganddrop.grade(submission[0], correct_answer):
//     correct = ['correct']
// else:
//     correct = ['incorrect']
//         </answer>"
