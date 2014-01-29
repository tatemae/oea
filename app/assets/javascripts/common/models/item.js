Oea.Item = Oea.ModelBase.extend({

  answers: Ember.ArrayProxy.create(),

  init: function(){
    this.get('answers').set('content', Oea.Answer.parseAnswers(this.get('xml')));
  }

});

Oea.Item.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Oea.Item.create({
      'id': xml.attr('ident'),
      'title': xml.attr('title'),
      'xml': xml
    });
  },

  parseItems: function(xml){
    return this._listFromXml(xml, 'item', Oea.Item);
  }

});