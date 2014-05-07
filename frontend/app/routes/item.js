import ItemResult from '../models/item_result';

export default Ember.Route.extend({
  beforeModel: function(transition){
    var item = this.get('currentModel')
    if(!Ember.isNone(item)){
      var start = item.get('start');
      if(!Ember.isNone(start)){
        var end = this.currentTime();
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

    return this.modelFor('items').findBy('id', params.item_id);
  },

  afterModel: function(model, transition){
    model.set('start', this.currentTime())
  },

  currentTime: function() {
    return new Date().getTime();
  },
});
