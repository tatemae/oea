var ModelBase = require('./model_base');

var Item = ModelBase.extend({

});

Item.reopenClass({

  from_xml: function(xml){
    xml = $(xml);
    return Item.create({
      id: xml.attr('ident'),
      title: xml.attr('title'),
      xml: xml
    });
  },

  list_from_xml: function(xml){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find('item'), function(i, item_xml){
      list.pushObject(Section.from_xml(item_xml));
    });
    return list;
  }

});

module.exports = Item;