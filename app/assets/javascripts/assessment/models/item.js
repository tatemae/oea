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
  }

});

module.exports = Item;