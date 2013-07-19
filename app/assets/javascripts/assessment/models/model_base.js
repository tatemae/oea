var ModelBase = Ember.Object.extend({

  text_from_xml: function(selector){
    return this.xml.find(selector).text();
  }

});

ModelBase.reopenClass({

  _list_from_xml: function(xml, selector, klass){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find(selector), function(i, x){
      list.pushObject(klass.from_xml(x));
    });
    return list;
  }

});

module.exports = ModelBase;