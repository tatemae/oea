Oea.AnswerController = Ember.ObjectController.extend({

  isSelected: false,

  text: function(){
    return this.get('content').textFromXml('material > mattext');
  }.property(),

  select: function(){
    this.set('isSelected', true);
  }

});
