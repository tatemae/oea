import Ember from 'ember';
import Base from "./base";
import EdXAnswer from "./edx_answer";
import EdX from "../utils/edx";

var EdXItem = Base.extend({

  result: null,
  choiceFeedback: null,
  selectedAnswerId: null,
  answers: null,

  init: function(){
    var content = EdXAnswer.parseAnswers(this.get('xml'));
    this.set('answers', Ember.ArrayProxy.create({ content : content }) );
  },

  material: function(){
    return EdX.buildProblemMaterial(this.get('xml'));
  }.property('xml'),

});

EdXItem.reopenClass({

  fromEdX: function(id, url, xml){
    xml = Ember.$(xml).find('problem').addBack('problem');
    if(xml.length > 0){
      var attrs = {
        'id': id,
        'url': url,
        'title': xml.attr('display_name'),
        'xml': xml,
        'standard': 'edX'
      };

      attrs.question_type = EdX.questionType(xml);

      return EdXItem.create(attrs);
    } else {
      return null;
    }
  }

});

export default EdXItem;
