Oea.Answer = Oea.ModelBase.extend({

  material: function(){
    return Oea.Qti.buildMaterial(this.get('xml').find('material').children());
  }.property('xml')

});

Oea.Answer.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Oea.Answer.create({
      'id': xml.attr('ident'),
      'xml': xml
    });
  },

  parseAnswers: function(xml){
    return Oea.Qti.listFromXml(xml, 'response_lid > render_choice > response_label', Oea.Answer);
  }

});