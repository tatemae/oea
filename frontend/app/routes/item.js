import ItemResult from '../models/item_result';

export default Ember.Route.extend({
  beforeModel: function(transition){
    var item = this.get('currentModel')
    if(!Ember.isNone(item)){
      var start = item.get('start');
      if(!Ember.isNone(start)){
        var end = this.currentTime();
        console.log('time:');
        console.log(end - item.get('start'));
        ItemResult.create({
          assessment: this.modelFor('application'),
          resultsEndPoint: OEA_SETTINGS.resultsEndPoint,
          user_id: OEA_SETTINGS.userId,
          item_id: item.id,
          identifier: item.id,
          timeSpent: end - start
        }).save();
        item.set('start', null);
      }
    }
  },

  model: function(params){

    // Record that the item was viewed
    ItemResult.create({
      assessment: this.modelFor('application'),
      resultsEndPoint: OEA_SETTINGS.resultsEndPoint,
      user_id: OEA_SETTINGS.userId,
      item_id: params.item_id,
      identifier: params.item_id
    }).save();

    var model = this.modelFor('items').findBy('id', params.item_id);

    model.set('start', null);

    return model;
  },

  afterModel: function(model, transition){
    model.set('start', this.currentTime())
  },

  deactivate: function() {
    this.get('currentModel').set('start', null);
  },

  currentTime: function() {
    return new Date().getTime();
  },
});
