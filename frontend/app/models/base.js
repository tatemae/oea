import Ember from 'ember';
import Utils from '../utils/utils';

var ajax = require('ic-ajax');

export default Ember.Object.extend(Ember.Evented, {

  crawlEdX: function(children, baseUrl, callback){
    var promises = [];
    Ember.$.each(children, function(i, child){
      var id = Ember.$(child).attr('url_name');
      var url = baseUrl + id + '.xml';
      if(this.get('offline')){
        var data = Utils.htmlDecodeWithRoot(Ember.$('#' + id).html());
        callback(id, url, data);
      } else {
        var promise = this.makeAjax(url, function(data){
          callback(id, url, data);
        }.bind(this));
        promises.push(promise);
      }
    }.bind(this));
    return promises;
  },

  makeAjax: function(url, callback, retried){
    var promise = ajax.request(url);
    promise.then(function(data){
      callback(data);
    }.bind(this), function(result){
      if(!retried && Utils.getLocation(url).hostname != Utils.getLocation(location.href).hostname){
        this.makeAjax('/proxy?url=' + encodeURI(url), callback, true)
      } else {
        console.log(result.statusText);
        this.trigger('error');
      }
    }.bind(this));
    return promise;
  }

});