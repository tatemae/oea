var ModelBase = require('./model_base');
var Item = require('./item');

var Section = ModelBase.extend({

  items: function(){
    var model = this;
    return new Ember.RSVP.Promise(function(resolve, reject){
      return resolve(Item.list_from_xml(model.xml));
    });
  }

});

Section.reopenClass({

  find: function(sections, section_id){
    return new Ember.RSVP.Promise(function(resolve, reject){
      var section = sections.find(function(section, index, enumerable){
        if(section.id == section_id){
          return section;
        }
      });
      if(section){
        resolve(section);
      } else {
        reject('No section found with id: ' + section_id);
      }
    });
  },

  from_xml: function(xml){
    xml = $(xml);
    return Section.create({
      id: xml.attr('ident'),
      xml: xml
    });
  },

  list_from_xml: function(xml){
    return this._list_from_xml(xml, 'section', Section);
  }

});

module.exports = Section;

