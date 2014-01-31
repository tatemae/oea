Oea.Item = Oea.ModelBase.extend({

  material: function(){
    return this.buildMaterial(this.get('xml').find('presentation > material').children());
  }.property('xml'),

  answers: function(){
    return Oea.Answer.parseAnswers(this.get('xml'));
  }.property('xml')

});

Oea.Item.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    var attrs = {
      'id': xml.attr('ident'),
      'title': xml.attr('title'),
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