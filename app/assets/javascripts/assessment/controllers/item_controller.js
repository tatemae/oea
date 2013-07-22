var ItemController = Ember.ObjectController.extend({

  selectedAnswer: null,

  text: function(){
    return this.get('content').text_from_xml('presentation > material > mattext');
  }.property('model'),

  answers: function(){
    return this.get('content').answers();
  }.property('model'),

  check_answer: function(){

  }

});

module.exports = ItemController;

