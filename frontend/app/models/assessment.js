import ModelBase from "./_model_base";

export default Assessment = ModelBase.extend({

  qtiUrl: '',
  sections: Ember.ArrayProxy.create(),

  init: function(){
    $.get(this.get('qtiUrl'), function(xml){
      this.parseAssessment(xml);
      this.trigger('loaded');
    }.bind(this)).fail(function(){
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
    this.get('sections').set('content', Oea.Section.parseSections(xml));
  }

});
