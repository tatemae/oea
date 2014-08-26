import Ember from 'ember';
import EdX from "../utils/edx";

export default Ember.Component.extend({

  drugged: {}, // All draggables that have been drug.

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
    answer = answer.replace(/'/g, '"');
    return JSON.parse(answer);
  }.property('content.xml'),

  checkAnswers: function(){
    var drugged = this.get('drugged');
    var graded = {};
    var correct = this.get('correctAnswer');
    if(correct && typeof correct === typeof {}){
      Ember.$.map(correct, function(answer, id){
        var node = drugged[id];
        graded[id] = {
          correct: false,
          feedback: '',
          score:  0
        };
        if(node){
          if((node.x < (answer[0][0] + answer[1]) || node.x > (answer[0][0] - answer[1])) &&
             (node.y < (answer[0][1] + answer[1]) || node.y > (answer[0][1] - answer[1]))){
            graded[id].correct = true;
            graded[id].score = 1;
          }
        }
      }.bind(this));
    }
    this.get('content').set('graded', graded);
  },

  didInsertElement: function(){

    this.$('.dropzone').each(function(i, element){
      this.enableDroppable(element);
    }.bind(this));

    this.$('.draggable').each(function(i, element){
      this.enableDraggable(element);
    }.bind(this));

  },

  enableDroppable: function(element){
    interact(element)
      // enable draggables to be dropped into this
      .dropzone(true)
      // only accept elements matching this CSS selector
      .accept('.draggable')
      // listen for drop related events
      .on('dragenter', function(event){
        // feedback the possibility of a drop
        event.target.classList.add('drop-target');
        event.relatedTarget.classList.add('can-drop');
      })
      .on('dragleave', function(event){
        // remove the drop feedback style
        event.target.classList.remove('drop-target');
        event.relatedTarget.classList.remove('can-drop');
      })
      .on('drop', function(event){
        // remove the drop feedback style
        event.target.classList.remove('drop-target');
        var drugged = this.get('drugged');
        drugged[event.relatedTarget.id] = {
          x: event.relatedTarget.x,
          y: event.relatedTarget.y
        };
        this.set('drugged', drugged);
        this.checkAnswers();
      }.bind(this));
  },

  enableDraggable: function(element){
    var startX = 0;
    var startY = 0;
    interact(element)
      .draggable({
        onstart: function(event){
          var target = event.target;
          startX = target.x|0;
          startY = target.y|0;
        },
        onmove: function(event){
          var target = event.target;
          target.x = (target.x|0) + event.dx;
          target.y = (target.y|0) + event.dy;
          target.style.webkitTransform = target.style.transform = 'translate(' + target.x + 'px, ' + target.y + 'px)';
        },
        onend: function(event){
          var target = event.target;
          if(!Ember.$(target).hasClass('can-drop')){
            target.x = startX;
            target.y = startY;
            target.style.webkitTransform = target.style.transform = 'translate(' + startX + 'px, ' + startY + 'px)';
          }
        }
      })
      .inertia(true);
  }

});


