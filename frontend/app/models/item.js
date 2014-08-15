import Ember from 'ember';
import Base from "./base";
import Answer from "./answer";
import Qti from "../utils/qti";

var Item = Base.extend({

  result: null,
  choiceFeedback: null,
  selectedAnswerId: null,

  material: function(){
    var material = this.get('xml').find('presentation > material').children();
    if(material.length > 0){
      return Qti.buildMaterial(material);
    }

    var flow = this.get('xml').find('presentation > flow');
    if(flow.length > 0){
      return this.reduceFlow(flow);
    }

  }.property('xml'),

  reduceFlow: function(flow){
    var result = '';
    Ember.$.each(flow.children(), function(i, node){
      if(node.nodeName.toLowerCase() === 'flow'){
        result += Qti.buildMaterial(Ember.$(node).find('material').children());
      } else if(node.nodeName.toLowerCase() === 'response_grp'){
        result += Qti.buildResponseGroup(node);
      }
    });
    return result;
  },

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

    var response_grp = xml.find('response_grp');
    if(response_grp){
      if(response_grp.attr('rcardinality') === 'Multiple'){
        attrs.question_type = 'drag_and_drop';
      }
    }

    return Item.create(attrs);
  },

  parseItems: function(xml){
    return Qti.listFromXml(xml, 'item', Item);
  }

});

export default Item;
