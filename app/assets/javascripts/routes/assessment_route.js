Oea.AssessmentsRoute = Ember.Route.extend({
	model: function() {
		return Oea.Assessment.find();
	}
});