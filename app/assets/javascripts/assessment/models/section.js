var ModelBase = require('./model_base');

var Section = ModelBase.extend({

  items: function(){
    var list = Ember.A();
    $.each(this.xml.find('item'), function(i, item_xml){
      list.pushObject(Item.from_xml(item_xml));
    });
    return list;
  }

});

Section.reopenClass({

  from_xml: function(xml){
    xml = $(xml);
    return Section.create({
      id: xml.attr('ident'),
      xml: xml
    });
  }

});

module.exports = Section;