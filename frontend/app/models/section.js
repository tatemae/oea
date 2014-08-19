import Ember from 'ember';
import Base from "./base";
import Item from "./item";
import Qti from "../utils/qti";

var Section = Base.extend({

  items: Ember.ArrayProxy.create({ content: Ember.A() }),

  init: function(){
    if(this.get('standard') == 'qti'){
      this.get('items').set('content', Item.parseItems(this.get('xml')));
    }
  }

});

Section.reopenClass({

  fromXml: function(xml){
    xml = Ember.$(xml);
    return Section.create({
      'id': xml.attr('ident'),
      'standard': 'qti',
      'xml': xml
    });
  },

  // Not all QTI files have sections. If we don't find one we build a default one to contain the items from the QTI file.
  buildDefault: function(xml){
    return Section.create({
      'id': 'default',
      'standard': 'qti',
      'xml': xml
    });
  },

  fromEdXVertical: function(id, url, xml){
    xml = Ember.$(xml).find('vertical');
    return Section.create({
      'id': id,
      'url': url,
      'standard': 'edX',
      'xml': xml
    });
  },

  parseSections: function(xml){
    return Qti.listFromXml(xml, 'section', Section);
  }

});

export default Section;
