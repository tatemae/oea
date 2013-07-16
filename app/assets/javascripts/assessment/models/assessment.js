var ModelBase = require('./model_base');
var Assessment = ModelBase.extend({

});

var base_uri = 'http://localhost:3010/api/assessments';

Assessment.reopenClass({
  all: function(){
    return $.get(base_uri, {
    }).then(function(xml){
      var assessments = Ember.A();
      $.each($(xml).find('assessment'), function(i, assessment){
        assessment = $(assessment);
        assessments.pushObject(Assessment.create({
          id: assessment.find('id').text(),
          title: assessment.find('title').text(),
          description: assessment.find('description').text()
        }));
      });
      return assessments;
    });
  },

  find: function(assessment_id){
    return $.get(base_uri + '/' + assessment_id + '.xml', {
    }).then(function(xml) {
      return xml;
    });
  }

});

module.exports = Assessment;
