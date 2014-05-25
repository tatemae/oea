import ItemResult from '../models/item_result';
import Utils from '../utils/utils';

export default Ember.Route.extend({

  model: function(params){
    // Record that the item was viewed
    ItemResult.create({
      assessment: this.modelFor('application'),
      resultsEndPoint: this.get('settings').get('resultsEndPoint'),
      user_id: this.get('settings').get('userId'),
      item_id: params.item_id,
      identifier: params.item_id
    }).save();

    return this.modelFor('items').findBy('id', params.item_id);
  },

  afterModel: function(model, transition){
    if(!Ember.isNone(model)){
      model.set('start', Utils.currentTime());
    }
  },
});
