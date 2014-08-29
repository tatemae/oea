import Ember from 'ember';
import EdX from "../utils/edx";
import EdXBase from './edx-base';

export default EdXBase.extend({

  question: function(){
    var question = EdX.buildProblemMaterial(this.get('content.xml'));
    return question;
  }.property('content.xml'),

  solution: function(){
    return this.get('content.xml').find('solution').html();
  }.property('content.xml')

});