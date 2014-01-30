Oea.Item = Oea.ModelBase.extend({

  answers: Ember.ArrayProxy.create(),

  init: function(){
    this.get('answers').set('content', Oea.Answer.parseAnswers(this.get('xml')));
  }

});

Oea.Item.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    var attrs = {
      'id': xml.attr('ident'),
      'title': xml.attr('title'),
      'text': xml.find('presentation > material > mattext').text(),
      'xml': xml
    };

    $.each(xml.find('itemmetadata > qtimetadata > qtimetadatafield'), function(i, x){
      attrs[$(x).find('fieldlabel').text()] = $(x).find('fieldentry').text();
    });

    return Oea.Item.create(attrs);
  },

  parseItems: function(xml){
    return this._listFromXml(xml, 'item', Oea.Item);
  }

});