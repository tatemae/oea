import Base from "./base";
import Section from "./section";
var ajax = require('ic-ajax');

export default Base.extend({

  qtiUrl: '',
  sections: Ember.ArrayProxy.create(),

  init: function(){
    ajax.request(this.get('qtiUrl')).then(function(xml){
      this.parseAssessment(xml);
      this.trigger('loaded');
    }.bind(this), function(result){
      console.log(result.statusText);
      this.trigger('error');
    }.bind(this));
  },

  parseAssessment: function(xml){
    xml = $(xml);
    var assessment = xml.find('assessment');
    this.setProperties({
      'xml':   xml,
      'id':    assessment.attr('ident'),
      'title': assessment.attr('title')
    });
    this.get('sections').set('content', Section.parseSections(xml));
  }

});
