var ItemsController = Ember.ArrayController.extend({

  item: null,
  needs: "item",
  itemBinding: "controllers.item.content",

  atBegin: true,
  atEnd: false,

  next: function(){
    this.move(1);
  },

  previous: function(){
    this.move(-1);
  },

  move: function(delta){
    var items = this.get('content');
    var index = items.indexOf(this.item) + delta;
    var end = items.get('length')-1;
    this.set('atBegin', index === 0);
    this.set('atEnd', index == end);
    if (index >= 0 && index <= end) {
      this.transitionToRoute('item', items.objectAt(index));
    }
  }

});

module.exports = ItemsController;
