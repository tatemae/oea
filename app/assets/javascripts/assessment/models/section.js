var ModelBase = require('./model_base');
var Item = require('./item');

var Section = ModelBase.extend({

  items: function(){
    var _self = this;
    return new Ember.RSVP.Promise(function(resolve, reject){
      if(!_self.xml){
        Assessment.get_xml(_self.id).then(function(xml){
          _self.xml = xml;
          return resolve(Item.list_from_xml(_self.xml));
        });
      } else {
        return resolve(Item.list_from_xml(_self.xml));
      }
    });
  }

});

Section.reopenClass({

  from_xml: function(xml){
    xml = $(xml);
    return Section.create({
      id: xml.attr('ident'),
      xml: xml
    });
  },

  list_from_xml: function(xml){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find('section'), function(i, section_xml){
      list.pushObject(Section.from_xml(section_xml));
    });
    return list;
  }

});

module.exports = Section;