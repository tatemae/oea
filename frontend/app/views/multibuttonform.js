export default Ember.View.extend({
  tagName: 'form',
  classNames: ['edit_item'],
  submit: function(event) {
    event.preventDefault();
    this.get('controller').send('checkAnswer', document.activeElement.value);
  }
});
