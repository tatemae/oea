var ModelBase = require('./model_base');
var Section = require('./section');

var Assessment = ModelBase.extend({

  sections: function(){
    var _self = this;
    return new Ember.RSVP.Promise(function(resolve, reject){
      if(!_self.xml){
        Assessment.get_xml(_self.id).then(function(xml){
          _self.xml = xml;
          return resolve(Section.list_from_xml(_self.xml));
        });
      } else {
        return resolve(Section.list_from_xml(_self.xml));
      }
    });
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
    return new Ember.RSVP.Promise(function(resolve, reject){
      // Cached assessment
      if(Assessment.assessments[assessment_id]){
        return resolve(Assessment.assessments[assessment_id]);
      }
      setTimeout(function(){
        if(!assessment_id){
          return $.get(base_uri + '.xml', {}).then(function(xml){
            var assessments = Ember.A();
            $.each($(xml).find('assessment'), function(i, assessment){
              assessments.pushObject(Assessment.from_xml(assessment, false));
            });
            return resolve(assessments);
          });
        } else {
          return Assessment.get_xml(assessment_id).then(function(xml){
            var assessment = $(xml).find('assessment').first();
            Assessment.assessments[assessment_id] = Assessment.from_xml(assessment, true);
            return resolve(Assessment.assessments[assessment_id]);
          });
        }
        reject('No assessment found with id: ' + assessment_id);
      }, 1000);
    });
  },

  get_xml: function(assessment_id){
    return $.get(base_uri + '/' + assessment_id + '.xml', {});
  },

  from_xml: function(xml, include_xml){
    xml = $(xml);
    attrs = {
      id: xml.attr('ident'),
      title: xml.attr('title')
    };
    if(include_xml){
      attrs.xml = xml;
    }
    return Assessment.create(attrs);
  }

});

module.exports = Assessment;


function Section(id, callback) {
  return new Ember.RSVP.Promise(function(resolve, reject){
    setTimeout(function() {
      if (!id)
        return resolve(sections);
      if (sections[id])
        return resolve(sections[id])
      reject('no section found with id: ' + id);
    }, 1000);
  });
}