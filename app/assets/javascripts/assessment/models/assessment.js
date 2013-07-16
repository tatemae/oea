var ModelBase = require('./model_base');
var Section = require('./section');

var Assessment = ModelBase.extend({

  sections: function(){
    var list = Ember.A();
    $.each(this.xml.find('section'), function(i, section_xml){
      list.pushObject(Section.from_xml(section_xml));
    });
    return list;
  }

});

var base_uri = 'http://localhost:3010/api/assessments';

Assessment.reopenClass({

  assessments: {},

  all: function(){
    return $.get(base_uri + '.xml', {
    }).then(function(xml){
      var assessments = Ember.A();
      $.each($(xml).find('assessment'), function(i, assessment){
        assessments.pushObject(Assessment.from_xml(assessment, false));
      });
      return assessments;
    });
  },

  find: function(assessment_id){
    // Keep a cache of the assessments.
    if(Assessment.assessments[assessment_id]){
      var defer = new $.Deferred();
      defer.resolve(Assessment.assessments[assessment_id]);
      return defer;
    }
    return $.get(base_uri + '/' + assessment_id + '.xml', {
    }).then(function(xml){
      var assessment = $(xml).find('assessment').first();
      Assessment.assessments[assessment_id] = Assessment.from_xml(assessment, true);
      return Assessment.assessments[assessment_id];
    });
  },

  from_xml: function(xml){
    xml = $(xml);
    return Assessment.create({
      id: xml.attr('ident'),
      title: xml.attr('title'),
      xml: xml
    });
  }

});

module.exports = Assessment;
