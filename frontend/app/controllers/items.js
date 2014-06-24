import Utils from '../utils/utils';

export default Ember.ArrayController.extend({

  item: null,
  needs: "item",
  itemBinding: "controllers.item.content",

  actions: {
    next: function(){
      this.move(1);
    },

    previous: function(){
      this.move(-1);
    },

    start: function(){
      this.set('start', Utils.currentTime());
      //set some value started = true
      this.set('started', true);
    }
  },

  showStart: function(){
    var started = this.get('started') || false;
    var settings = this.get('settings');
    return (settings.get('enableStart') === "true" || settings.get('enableStart') === true) && started === false;
  }.property("started"),

  hideNavigation: function(){
    return this.get('content.length') <= 1;
  }.property('content'),

  atBegin: function(){
    return this.index() === 0;
  }.property('item'),

  atEnd: function(){
    return this.index() === this.get('length') - 1;
  }.property('item'),

  current: function(){
    return this.index() + 1;
  }.property('item'),

  index: function(){
    var index = 0;
    this.get('content').find(function(item, i, enumerable){
      if(this.item.id === item.id){
        index = i;
        return true;
      }
    }, this);
    return index;
  },

  move: function(delta){
    var new_index = this.index() + delta;
    if (new_index >= 0 && new_index <= this.get('length') - 1){
      this.transitionToRoute('item', this.get('content').objectAt(new_index));
    }
  }

});
