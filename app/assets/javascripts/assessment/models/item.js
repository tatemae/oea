var Item = DS.Model.extend({
  section: DS.belongsTo('App.Section')
});

module.exports = Item;
