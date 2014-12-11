import Ember from 'ember';
import Base from "./base";

import Section from "./section";

import EdXSection from "./edx_section";
import EdXItem from "./edx_item";


export default Base.extend({

  srcUrl: '',
  srcData: null,
  offline: false,
  sections: Ember.ArrayProxy.create({ content: Ember.A() }),
  keywords: [],
  standard: '',
  objectives: [],

  loadAndParse: function(){
    if(this.get('offline')){
      this.parseAssessment(this.get('srcData'));
    } else {
      this.makeAjax(this.get('srcUrl'), this.parseAssessment.bind(this));
    }
  },

  parseAssessment: function(data){
    var xml = Ember.$(data);
    var assessment = xml.find('assessment').addBack('assessment');
    var questestinterop = xml.find('questestinterop').addBack('questestinterop');
    var sequential = xml.find('sequential').addBack('sequential');
    this.set('xml', xml);
    if(assessment.length > 0 || questestinterop.length > 0){
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

    this.padArray(this.get('sections'), sequential.children());
    
    var promises = this.crawlEdX(sequential.children(), baseUrl + 'vertical/', function(id, url, data){
      var section = EdXSection.fromEdX(id, url, data);

      this.findAndSetObject(this.get('sections'), section);

      var children = section.get('xml').children();
      this.padArray(section.get('items'), children);
      var sectionPromises = this.crawlEdX(children, baseUrl + 'problem/', function(id, url, data){
        var item = EdXItem.fromEdX(id, url, data);
        if(item){
          this.findAndSetObject(section.get('items'), item);
        }
      }.bind(this));
      if(promises){
        Ember.RSVP.Promise.all(promises.concat(sectionPromises)).then(function(){
          this.trigger('loaded');
        }.bind(this));
      } else {
        this.trigger('loaded');
      }
    }.bind(this));
  }

});