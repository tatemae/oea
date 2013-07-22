var AnswerController = Ember.ObjectController.extend({

  isSelected: false,

  text: function(){
    return this.get('content').text_from_xml('material > mattext');
  }.property(),

  select: function(){
    this.set('isSelected', true);
  }

});

module.exports = AnswerController;

