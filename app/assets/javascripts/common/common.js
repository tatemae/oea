//= require jquery
//= require handlebars
//= require ember

//= require_self

//= require_tree ./utils
//= require_tree ./models
//= require_tree ./templates
//= require_tree ./components


Oea = Ember.Application.create({

  //Enable logging by uncommenting:
  LOG_STACKTRACE_ON_DEPRECATION : true,
  LOG_BINDINGS                  : true,
  LOG_TRANSITIONS               : true,
  LOG_TRANSITIONS_INTERNAL      : true,
  LOG_VIEW_LOOKUPS              : true,
  LOG_ACTIVE_GENERATION         : true,

  // The resolver is required since we have namespaced the ember app under 'oea'
  Resolver: Ember.DefaultResolver.extend({
    resolveTemplate: function(parsedName){
      var fullNameWithoutType = parsedName.fullNameWithoutType;
      parsedName.fullNameWithoutType = OeaNamespace + "/" + fullNameWithoutType;
      var result = this._super(parsedName);
      if(!result){
        parsedName.fullNameWithoutType = "common/" + fullNameWithoutType;
        result = this._super(parsedName);
      }
      return result;
    }
  })

});