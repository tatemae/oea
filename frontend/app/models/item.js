Oea.Item = Oea.ModelBase.extend({

  result: null,
  choiceFeedback: null,
  selectedAnswerId: null,

  material: function(){
    return Oea.Qti.buildMaterial(this.get('xml').find('presentation > material').children());
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

    if(xml.find('itemmetadata > qmd_itemtype').text() == 'Multiple Choice'){
      attrs.question_type = 'multiple_choice_question';
    }

    return Oea.Item.create(attrs);
  },

  parseItems: function(xml){
    return Oea.Qti.listFromXml(xml, 'item', Oea.Item);
  }

});