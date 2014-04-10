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

  // Not all QTI files have sections. If we don't find one we build a default one to contain the items from the QTI file.
  buildDefault: function(xml){
    return Oea.Section.create({
      'id': 'default',
      'xml': xml
    });
  },

  parseSections: function(xml){
    return Oea.Qti.listFromXml(xml, 'section', Oea.Section);
  }

});
