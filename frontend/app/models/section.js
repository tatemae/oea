import Base from "./base";
import Item from "./item";
import Qti from "../utils/qti";

var Section = Base.extend({

  items: Ember.ArrayProxy.create(),

  init: function(){
    this.get('items').set('content', Item.parseItems(this.get('xml')));
  }

});

Section.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Section.create({
      'id': xml.attr('ident'),
      'xml': xml
    });
  },

  // Not all QTI files have sections. If we don't find one we build a default one to contain the items from the QTI file.
  buildDefault: function(xml){
    return Section.create({
      'id': 'default',
      'xml': xml
    });
  },

  parseSections: function(xml){
    return Qti.listFromXml(xml, 'section', Section);
  }

});

export default Section;
