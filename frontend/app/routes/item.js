import ItemResult from "../models/item_result";

export default Ember.Route.extend({
  beforeModel: function(transition){
    if(typeof start !== "undefined")
    {
      this.endTimeOnQuestion();
      var item = this.get('currentModel');
      console.log("time spent" + end - start);
      Oea.ItemResult.create({
        assessment: this.modelFor('application'),
        resultsEndPoint: OEA_SETTINGS.resultsEndPoint,
        user_id: OEA_SETTINGS.userId,
        item_id: item.id,
        identifier: item.id,
        timeSpent: end - start
      }).save();
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
    this.startTimeOnQuestion();
  },

  startTimeOnQuestion: function() {
    this.start = new Date().getTime();
  },

  endTimeOnQuestion: function() {
    this.end = new Date().getTime();
  }


});
