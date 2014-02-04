Oea.ItemRoute = Ember.Route.extend({

  model: function(params){

    // Record that the item was viewed
    Oea.ItemResult.create({
      assessment: this.modelFor('application'),
      resultsEndPoint: OEA_SETTINGS.resultsEndPoint,
      user_id: OEA_SETTINGS.userId,
      item_id: params.item_id,
      identifier: params.item_id
    }).save();

    return this.modelFor('items').findBy('id', params.item_id);
  }

});
