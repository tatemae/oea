Oea.ModelBase = Ember.Object.extend(Ember.Evented, {

  textFromXml: function(selector){
    return this.xml.find(selector).text();
  }

});

Oea.ModelBase.reopenClass({

  _listFromXml: function(xml, selector, klass){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find(selector), function(i, x){
      list.pushObject(klass.fromXml(x));
    });
    if(list.length <= 0 && klass.buildDefault){
      list.pushObject(klass.buildDefault(xml));
    }
    return list;
  }

});
