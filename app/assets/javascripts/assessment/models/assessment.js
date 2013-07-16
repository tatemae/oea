var ModelBase = require('./model_base');
var Assessment = ModelBase.extend({

});

var base_uri = 'http://localhost:3010/api/assessments';

Assessment.reopenClass({
  all: function(){
    return $.get(base_uri + '.xml', {
    }).then(function(xml){
      var assessments = Ember.A();
      $.each($(xml).find('assessment'), function(i, assessment){
        assessments.pushObject(Assessment.xml_to_assessment(assessment));
      });
      return assessments;
    });
  },

  find: function(assessment_id){
    return $.get(base_uri + '/' + assessment_id + '.xml', {
    }).then(function(xml){
      var assessment = $(xml).find('assessment').first();
      return Assessment.xml_to_assessment(assessment);
    });
  },

  xml_to_assessment: function(xml){
    xml = $(xml);
    return Assessment.create({
      id: xml.attr('ident'),
      title: xml.attr('title'),
      xml: xml
    });
  }

});

module.exports = Assessment;
