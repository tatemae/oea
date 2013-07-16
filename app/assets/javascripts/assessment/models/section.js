var ModelBase = require('./model_base');

var Section = ModelBase.extend({

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