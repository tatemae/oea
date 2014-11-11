import Ember from 'ember';
import Base from "./base";

var EdXSection = Base.extend({

  init: function(){
    this.set('items', Ember.ArrayProxy.create({ content : Ember.A() }) );
  }

});

EdXSection.reopenClass({

  fromEdX: function(id, url, xml){
    xml = Ember.$(xml).find('vertical').addBack('vertical');
    return EdXSection.create({
      'id': id,
      'url': url,
      'standard': 'edX',
      'xml': xml
    });
  }

});

export default EdXSection;
