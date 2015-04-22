import Ember from 'ember';
import Utils from '../utils/utils';

export default Ember.Object.extend({
  params: function() {
    var queryDict = {};
    var vars = window.location.search.substring(1).split('&');
    for (var i = 0; i < vars.length; i++){
      var pair = vars[i].split('=');
      queryDict[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
    }
    return queryDict;
  }.property(),

  srcUrl: function(){
    return this.bestValue('srcUrl', 'src_url');
  }.property('params'),

  srcData: function(){
    var result = Utils.htmlDecodeWithRoot(Ember.$('#srcData').html());
    if(Ember.$(result).length == 1){ // We ended up with an empty <root> element. Try returning the raw result
      result = Ember.$('#srcData').html();
    }
    result = result.trim();
    result = result.replace('<![CDATA[', '');
    result = result.replace('<!--[CDATA[', '');
    if(result.slice(-3) == ']]>'){
      result = result.slice(0,-3);
    }
    return result;
  }.property(),

  offline: function(){
    return this.bestValue('offline', 'offline', false);
  }.property('params'),

  assessmentId: function(){
    return this.bestValue('assessmentId', 'assessment_id');
  }.property('params'),

  eId: function(){
    return this.bestValue('eId', 'eid');
  }.property('params'),

  externalUserId: function(){
    return this.bestValue('externalUserId', 'external_user_id');
  }.property('params'),

  keywords: function(){
    return this.bestValue('keywords', 'keywords');
  }.property('params'),

  resultsEndPoint: function(){
    return this.bestValue('resultsEndPoint', 'results_end_point', 'http://localhost:4200/api');
  }.property('params'),

  confidenceLevels: function(){
    return this.bestValue('confidenceLevels', 'confidence_levels', false);
  }.property('params'),

  enableStart: function(){
    return this.bestValue('enableStart', 'enable_start', false);
  }.property('params'),

  style: function(){
    var style = this.bestValue('style', 'style', null);
    if(style && style.indexOf('.css') < 0){
      style = '/assets/themes/' + style + '.css?body=1';
    }
    return style;
  }.property('params'),

  bestValue: function(settings_prop, params_prop, default_prop){
    if(typeof window.OEA_SETTINGS === 'undefined'){
      return this.get('params')[params_prop] || default_prop;
    } else {
      return window.OEA_SETTINGS[settings_prop];
    }
  }

});
