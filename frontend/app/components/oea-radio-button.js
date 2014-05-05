export default Ember.Component.extend({

  tagName : "input",
  type : "radio",
  attributeBindings : [ "name", "type", "value", "checked:checked" ],

  click : function() {
    this.set("selection", this.get("value"));
  },

  checked : function() {
    return this.get("value") === this.get("selection");
  }.property('selection')

});
