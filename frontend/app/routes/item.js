import ItemResult from '../models/item_result';
import Utils from '../utils/utils';

export default Ember.Route.extend({

  model: function(params){
    return this.modelFor('items').findBy('id', params.item_id);
  },

  afterModel: function(model, transition){
    var settings = this.get('settings');
    // Record that the item was viewed
    ItemResult.create({
      assessment_result_id: this.modelFor('application').get('assessment_result.id'),
      resultsEndPoint: this.get('settings').get('resultsEndPoint'),
      user_id: this.get('settings').get('userId'),
      eId: this.get('settings').get('eId'),
      src_url: settings.get('qtiUrl'),
      identifier: model.get('id')
    }).save();

    if(!Ember.isNone(model)){
      model.set('start', Utils.currentTime());
    }
  },
});
