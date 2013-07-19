var AnswerController = Ember.ObjectController.extend({

  text: function(){
    return this.get('content').text_from_xml('material > mattext');
  }.property()

});

module.exports = AnswerController;

