import Ember from 'ember';

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

  qtiUrl: function(){
    return this.bestValue('qtiUrl', 'src_url');
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
    if(typeof OEA_SETTINGS === 'undefined'){
      return this.get('params')[params_prop] || default_prop;
    } else {
      return OEA_SETTINGS[settings_prop];
    }
  }

});
