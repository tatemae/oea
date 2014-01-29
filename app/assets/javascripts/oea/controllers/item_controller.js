Oea.ItemController = Ember.ObjectController.extend({

  selectedAnswer: null,

  text: function(){
    return this.get('content').textFromXml('presentation > material > mattext');
  }.property('content'),

  answers: function(){
    return this.get('content').get('answers');
  }.property('content'),

  check_answer: function(){

  }

});
