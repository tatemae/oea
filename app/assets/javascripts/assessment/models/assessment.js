var ModelBase = require('./model_base');
var Assessment = ModelBase.extend({

});

Assessment.reopenClass({
  findAll: function(){
    return $.get("http://localhost:3010/api/assessments", {
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

  findOne: function(){
    return $.get("http://localhost:3010/api/assessments/1.xml", {
    }).then(function(xml) {
      return xml;
    });
  }

});

module.exports = Assessment;
