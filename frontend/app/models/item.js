import Ember from 'ember';
import Base from "./base";
import Answer from "./answer";
import Qti from "../utils/qti";

var Item = Base.extend({

  result: null,
  choiceFeedback: null,
  selectedAnswerId: null,

  material: function(){
    return Qti.buildMaterial(this.get('xml').find('presentation > material').children());
  }.property('xml'),

  answers: function(){
    return Answer.parseAnswers(this.get('xml'));
  }.property('xml')

});

Item.reopenClass({

  fromXml: function(xml){
    xml = Ember.$(xml);

    var objectives = [];
    xml.find('objectives matref').map(function(index, item){ return objectives.push( Ember.$(item).attr('linkrefid') ); });

    var attrs = {
      'id': xml.attr('ident'),
      'title': xml.attr('title'),
      'objectives': objectives,
      'xml': xml
    };

    Ember.$.each(xml.find('itemmetadata > qtimetadata > qtimetadatafield'), function(i, x){
      attrs[Ember.$(x).find('fieldlabel').text()] = Ember.$(x).find('fieldentry').text();
    });

    if(xml.find('itemmetadata > qmd_itemtype').text() === 'Multiple Choice'){
      attrs.question_type = 'multiple_choice_question';
    }

    return Item.create(attrs);
  },

  parseItems: function(xml){
    return Qti.listFromXml(xml, 'item', Item);
  }

});

export default Item;
