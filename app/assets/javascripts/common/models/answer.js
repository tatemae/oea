Oea.Answer = Oea.ModelBase.extend({

});

Oea.Answer.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Oea.Answer.create({
      'id': xml.attr('ident'),
      'text': xml.find('material > mattext').text(),
      'xml': xml
    });
  },

  parseAnswers: function(xml){
    return this._listFromXml(xml, 'response_lid > render_choice > response_label', Oea.Answer);
  }

});