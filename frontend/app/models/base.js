import Ember from 'ember';
import Utils from '../utils/utils';

var ajax = require('ic-ajax');

export default Ember.Object.extend(Ember.Evented, {

  crawlEdX: function(children, baseUrl, callback){
    var promises = [];
    Ember.$.each(children, function(i, child){
      var id = Ember.$(child).attr('url_name');
      if(id === undefined){ // Data is embedded in the document
        id = Utils.makeId();
        return callback(id, null, child);
      }
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

  // The children are loaded asyncronously but need to be ordered
  // the same way every time. Create placeholders that can later be used
  // to correctly order the children after their promises return.
  padArray: function(arrayProxy, children){
    Ember.$.each(children, function(i, child){
      var id = Ember.$(child).attr('url_name');
      arrayProxy.pushObject(id);
    }.bind(this));
  },

  // Find and set obj in the arrayProxy. This searches arrayProxy for an id
  // that matches the obj's id and replaces it with the obj.
  findAndSetObject: function(arrayProxy, obj){
    var idx = arrayProxy.indexOf(obj.get('id'));
    if(idx >= 0){
      arrayProxy.removeAt(idx);
      arrayProxy.insertAt(idx, obj);
    }
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