import Ember from 'ember';

var ajax = require('ic-ajax');

export default Ember.Object.extend(Ember.Evented, {

  crawlEdX: function(children, baseUrl, callback){
    var promises = [];
    Ember.$.each(children, function(i, child){
      var id = Ember.$(child).attr('url_name');
      var url = baseUrl + id + '.xml';
      var promise = this.makeAjax(url, function(data){
        callback(id, url, data);
      }.bind(this));
      promises.push(promise);
    }.bind(this));
    return promises;
  },

  makeAjax: function(url, callback){
    var promise = ajax.request(url);
    promise.then(function(data){
      callback(data);
    }.bind(this), function(result){
      console.log(result.statusText);
      this.trigger('error');
    }.bind(this));
    return promise;
  }

});