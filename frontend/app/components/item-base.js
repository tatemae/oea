import Ember from 'ember';
import MathJaxInit from "../utils/mathjax_init";

export default Ember.Component.extend({
  didInsertElement: function(){
    MathJaxInit.executeMathJax(window);
  }
});