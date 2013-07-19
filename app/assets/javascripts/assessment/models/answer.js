var ModelBase = require('./model_base');

var Answer = ModelBase.extend({

});

Answer.reopenClass({

  from_xml: function(xml){
    xml = $(xml);
    return Answer.create({
      id: xml.attr('ident'),
      xml: xml
    });
  },

  list_from_xml: function(xml){
    return this._list_from_xml(xml, 'response_lid > render_choice > response_label', Answer);
  }

});

module.exports = Answer;