import Ember from 'ember';
import Base from "./base";
import Section from "./section";
import Item from "./item";

export default Base.extend({

  srcUrl: '',
  sections: Ember.ArrayProxy.create({ content: Ember.A() }),
  keywords: [],
  standard: '',
  objectives: [],

  init: function(){
    this.makeAjax(this.get('srcUrl'), this.parseAssessment.bind(this));
  },

  parseAssessment: function(data){
    var xml = Ember.$(data);
    var assessment = xml.find('assessment');
    var sequential = xml.find('sequential');
    this.set('xml', xml);
    if(assessment.length > 0){
      this.parseQti(assessment, xml);
    } else if(sequential.length > 0){
      this.parseEdX(sequential);
    }
  },

  parseQti: function(assessment, xml){
    this.setProperties({
      'id':    assessment.attr('ident'),
      'title': assessment.attr('title'),
      'standard': 'qti'
    });
    Ember.$.each(xml.find('assessment > objectives matref'), function(index, item){
      this.get('objectives').push(Ember.$(item).attr('linkrefid'));
    }.bind(this));
    this.get('sections').set('content', Section.parseSections(xml));
    this.trigger('loaded');
  },

  parseEdX: function(sequential){
    var url = this.get('srcUrl');
    var id = url.slice(url.indexOf('sequential')).replace('.xml', '');
    this.setProperties({
      'id':    id,
      'title': sequential.attr('display_name'),
      'standard': 'edX'
    });

    var baseUrl = url.substr(0, url.indexOf('sequential'));
    var promises = this.crawlEdX(sequential.children(), baseUrl + 'vertical/', function(id, url, data){
      var section = Section.fromEdXVertical(id, url, data);
      this.get('sections').pushObject(section);
      var sectionPromises = this.crawlEdX(section.get('xml').children(), baseUrl + 'problem/', function(id, url, data){
        var item = Item.fromEdXProblem(id, url, data);
        section.get('items').pushObject(item);
      });
      Ember.RSVP.Promise.all(promises.concat(sectionPromises)).then(function(){
        this.trigger('loaded');
      }.bind(this));
    }.bind(this));
  }

});