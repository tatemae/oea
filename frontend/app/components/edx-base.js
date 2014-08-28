import Ember from 'ember';
import EdX from "../utils/edx";

export default Ember.Component.extend({

  question: function(){
    return EdX.buildProblemMaterial(this.get('content.xml'));
  }.property('content.xml'),

  solution: function(){
    return this.get('content.xml').find('solution').html();
  }.property('content.xml'),

});