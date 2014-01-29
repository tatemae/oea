Oea.Section = Oea.ModelBase.extend({

  items: Ember.ArrayProxy.create(),

  init: function(){
    this.get('items').set('content', Oea.Item.parseItems(this.get('xml')));
  }

});

Oea.Section.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Oea.Section.create({
      'id': xml.attr('ident'),
      'xml': xml
    });
  },

  parseSections: function(xml){
    return this._listFromXml(xml, 'section', Oea.Section);
  }

});
