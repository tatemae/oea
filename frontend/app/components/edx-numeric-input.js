import Ember from 'ember';
import EdX from "../utils/edx";
import EdXBase from './edx-base';

export default EdXBase.extend({

  question: function(){
    var contents = Ember.$('<div>').append(this.get('content.xml').html());
    contents.find('solution').remove();

    contents.find('numericalresponse').each(function(i, numericalresponse){
      numericalresponse = $(numericalresponse);
      numericalresponse.replaceWith('<input type="text">');
    });

    return contents.html();

  }.property('content.xml'),

  solution: function(){
    return this.get('content.xml').find('solution').html();
  }.property('content.xml')

});