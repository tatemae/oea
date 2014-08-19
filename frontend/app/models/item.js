import Ember from 'ember';
import Base from "./base";
import Answer from "./answer";
import Qti from "../utils/qti";

var Item = Base.extend({

  result: null,
  choiceFeedback: null,
  selectedAnswerId: null,

  answers: Ember.ArrayProxy.create({ content: Ember.A() }),

  init: function(){
    if(this.get('standard') == 'qti'){
      this.get('answers').set('content', Answer.parseAnswers(this.get('xml')));
    }
  },

  material: function(){
    if(this.get('standard') == 'edX'){
      var contents = Ember.$('<div>').append(this.get('xml').html());
      contents.remove('solution');
      contents.remove('stringresponse');
      contents.remove('customresponse');
      return contents.html();
    } else if(this.get('standard') == 'qti'){
      var material = this.get('xml').find('presentation > material').children();
      if(material.length > 0){
        return Qti.buildMaterial(material);
      }

      var flow = this.get('xml').find('presentation > flow');
      if(flow.length > 0){
        return this.reduceFlow(flow);
      }
    }
    return '';
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
  }

});

Item.reopenClass({

  fromEdXProblem: function(id, url, xml){
    xml = Ember.$(xml).find('problem');
    var attrs = {
      'id': id,
      'url': url,
      'title': xml.attr('display_name'),
      'xml': xml,
      'standard': 'edX'
    };

    switch(xml.attr('display_name')){
      case 'Drag and Drop':
        attrs.question_type = 'drag_and_drop';
        break;
      case 'Numerical Input':
        attrs.question_type = ''; // Other edX types we don't yet support
        break;
      case 'Dropdown':
        attrs.question_type = '';
        break;
      case 'Multiple Choice':
        attrs.question_type = 'multiple_choice_question';
        break;
    }

    return Item.create(attrs);
  },

  fromXml: function(xml){
    xml = Ember.$(xml);

    var objectives = [];
    xml.find('objectives matref').map(function(index, item){ return objectives.push( Ember.$(item).attr('linkrefid') ); });

    var attrs = {
      'id': xml.attr('ident'),
      'title': xml.attr('title'),
      'objectives': objectives,
      'xml': xml,
      'standard': 'qti'
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
