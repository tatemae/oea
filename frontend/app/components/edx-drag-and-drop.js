import Ember from 'ember';
import EdX from "../utils/edx";

export default Ember.Component.extend({

  question: function(){
    return EdX.buildProblemMaterial(this.get('content.xml'));
  }.property('content.xml'),

  images: function(){
    var imgs = Ember.A();
    var dndRoot = this.get('content.xml').find('drag_and_drop_input');
    if(dndRoot.length > 0){
      var image = {
        src: dndRoot.attr('img'),
        title: 'Drag and Drop main image'
      };
      imgs.pushObject(image);
    }
    return imgs;
  }.property('content.xml'),

  isDroppableImage: function(){
    return this.get('targets').length <= 0;
  }.property('targets'),

  draggables: function(){
    return Ember.$.map(this.get('content.xml').find('draggable'), function(draggable){
      draggable = Ember.$(draggable);
      return {
        'id': draggable.attr('id'),
        'label': draggable.attr('label')
      };
    });
  }.property('content.xml'),

  targets: function(){
    return Ember.$.map(this.get('content.xml').find('target'), function(target){
      target = Ember.$(target);
      return {
        'id': target.attr('id'),
        'label': target.attr('label'),
        'style': 'top:' + target.attr('y') + 'px;left:' + target.attr('x') + 'px;width:' + target.attr('w') + 'px;height:' + target.attr('h') + 'px;'
      };
    });
  }.property('content.xml'),

  correctAnswer: function(){
    var answer = this.get('content.xml').find('answer').html();
    answer = answer.replace('correct_answer =', '');
    answer = answer.substring(0, answer.indexOf('if draganddrop.grade'));
    return eval(answer);
  }.property('content.xml'),

  checkAnswers: function(){
    var answer = this.get('correctAnswer');
    this.get('draggables').forEach(function(draggable){
      var pos = this.$('#' + draggable.id).position();
      var correct = answer[draggable.id];
    }.bind(this));
    this.get('content').set('score', 0);
  },

  didInsertElement: function(){

    interact('.dropzone')
      // enable draggables to be dropped into this
      .dropzone(true)
      // only accept elements matching this CSS selector
      .accept('.draggable')
      // listen for drop related events
      .on('dragenter', function(event){
        var draggableElement = event.relatedTarget;
        var dropzoneElement = event.target;
        // feedback the possibility of a drop
        dropzoneElement.classList.add('drop-target');
      })
      .on('dragleave', function(event){
        // remove the drop feedback style
        event.target.classList.remove('drop-target');
      })
      .on('drop', function(event){
        // remove the drop feedback style
        event.target.classList.remove('drop-target');
        this.checkAnswers();
      }.bind(this));

    //var dropzone = Ember.$('.panel-body');

    interact('.draggable')
      .draggable({
        onmove: function(event){
          var target = event.target;
          target.x = (target.x|0) + event.dx;
          target.y = (target.y|0) + event.dy;
          target.style.webkitTransform = target.style.transform = 'translate(' + target.x + 'px, ' + target.y + 'px)';
        }
      })
      .inertia(true);
      // .restrict({
      //   drag: dropzone[0]
      // });
  }

});


