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
    return this._list_from_xml(xml, 'item', Item);
  }

});

module.exports = Item;