var Adapter = DS.RESTAdapter.extend({
  namespace: 'api',
  ajax: function(url, type, hash){
    if(hash){
      var csrfToken = $('meta[name="csrf-token"]').attr('content');
      if(!hash.data){
        hash.data = {};
      }
      //hash.data.auth_token = $('meta[name="authentication-token"]').attr('content');
      hash.beforeSend = function(xhr){
        xhr.setRequestHeader('X-CSRF-Token', csrfToken);
      };
    }
    return this._super(url, type, hash);
  },
  pathForType: function(type) {
    var underscored = Ember.String.underscore(type);
    return Ember.String.pluralize(underscored);
  },
  ajaxError: function(jqXHR){
    if(jqXHR.status == 401){
      window.location.href = '/users/sign_in?timeout=true';
    }
    if(jqXHR){
      jqXHR.then = null;
    }
    return jqXHR;
  }
});

Oea.ApplicationAdapter = Adapter;
Oea.ApplicationSerializer = DS.ActiveModelSerializer.extend({
});