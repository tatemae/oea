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

  userId: function(){
    return this.bestValue('userId', 'userId', '1');
  }.property('params'),

  resultsEndPoint: function(){
    return this.bestValue('resultsEndPoint', 'results_end_point', 'http://localhost:4200/api');
  }.property('params'),

  confidenceLevels: function(){
    return this.bestValue('confidenceLevels', 'confidence_levels', false);
  }.property('params'),

  bestValue: function(settings_prop, params_prop, default_prop){
    if(OEA_SETTINGS){
      return OEA_SETTINGS[settings_prop];
    } else {
      return this.get('params')[params_prop] || default_prop;
    }
  }

});
