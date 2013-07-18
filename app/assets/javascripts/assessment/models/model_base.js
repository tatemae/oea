var ModelBase = Ember.Object.extend({
});

ModelBase.reopenClass({

  _list_from_xml: function(xml, type, klass){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find(type), function(i, x){
      list.pushObject(klass.from_xml(x));
    });
    return list;
  }

});

module.exports = ModelBase;