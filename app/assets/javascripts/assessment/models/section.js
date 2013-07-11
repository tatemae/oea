var Section = DS.Model.extend({
  assessment: DS.belongsTo('App.Assessment'),
  items: DS.hasMany('App.Item')
});

module.exports = Section;
