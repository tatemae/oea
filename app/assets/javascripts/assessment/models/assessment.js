var Assessment = DS.Model.extend({
  sections: DS.hasMany('App.Section')
});

module.exports = Assessment;
