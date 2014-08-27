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
      var style;
      if(this.get('labelBackgroundColor')){
        style = 'background-color:' + this.get('labelBackgroundColor') + ';';
      }
      return {
        'id': draggable.attr('id'),
        'label': draggable.attr('label'),
        'style': style
      };
    }.bind(this));
  }.property('content.xml'),

  targets: function(){
    return Ember.$.map(this.get('content.xml').find('target'), function(target){
      target = Ember.$(target);
      var style = 'top:' + target.attr('y') + 'px;left:' + target.attr('x') + 'px;width:' +
                  target.attr('w') + 'px;height:' + target.attr('h') + 'px;';
      return {
        'id': target.attr('id'),
        'label': target.attr('label'),
        'style': style
      };
    }.bind(this));
  }.property('content.xml'),

  correctAnswer: function(){
    var answer = this.get('content.xml').find('answer').html();
    answer = answer.replace('correct_answer =', '');
    answer = answer.substring(0, answer.indexOf('if draganddrop.grade'));
    answer = answer.replace(/'/g, '"');
    return JSON.parse(answer);
  }.property('content.xml'),

  onePerTarget: function(){
    return this.get('content.xml').find('drag_and_drop_input').attr('one_per_target') == "true";
  }.property('content.xml'),

  outlineTarget: function(){
    return this.get('content.xml').find('drag_and_drop_input').attr('target_outline') == "true";
  }.property('content.xml'),

  labelBackgroundColor: function(){
    return this.get('content.xml').find('drag_and_drop_input').attr('label_bg_color');
  }.property('content.xml'),

  checkAnswers: function(){
    var drugged = this.get('drugged');
    var graded = {};
    var correct = this.get('correctAnswer');
    if(correct){
      if(correct[0] && correct[0].targets){
        correct.forEach(function(answerSet){
          var rule = answerSet.rule || 'anyof';
          switch(rule){
            case 'anyof':
              answerSet.draggables.forEach(function(id){
                id = parseInt(id, 10);
                graded[id] = {
                  correct: false,
                  feedback: '',
                  score:  0
                };
                if(drugged[id] && answerSet.targets.contains(drugged[id].droppableId)){
                  graded[id].correct = true;
                  graded[id].score = 1;
                }
              });
            break;
            case 'exact':
            case 'unordered_equal':
            case 'anyof+number':
            case 'unordered_equal+number':
            break;
          }
        }.bind(this));
      } else {
        Ember.$.each(correct, function(answer, id){
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
    }
    this.get('content').set('graded', graded);
  },

  didInsertElement: function(){
    this.set('messages', Ember.A());

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
        var related = event.relatedTarget;
        var drugged = this.get('drugged');
        var alreadyOccupied = false;
        var targetId = event.target.id;
        if(this.get('onePerTarget')){
          // Determine if a target is already occupied
          Ember.$.each(this.get('drugged'), function(i, item){
            if(targetId == item.droppableId){
              this.get('messages').pushObject('Only one item per drop area.');
              alreadyOccupied = true;
            }
          }.bind(this));
        }
        if(alreadyOccupied){ // If the drop area is already occupied and we don't allow that state
          // reset the draggable
          this.moveBack(related);
        } else {
          drugged[related.id] = {
            x: related.x,
            y: related.y,
            droppableId: event.target.id
          };
          this.set('drugged', drugged);
        }

        this.checkAnswers();
      }.bind(this));
  },

  enableDraggable: function(element){
    var startX = 0;
    var startY = 0;
    interact(element)
      .draggable({
        onstart: function(event){
          this.clearPrompts();
          var target = event.target;
          startX = target.x|0;
          startY = target.y|0;
          target.classList.remove('can-drop');
        }.bind(this),
        onmove: function(event){
          var target = event.target;
          target.x = (target.x|0) + event.dx;
          target.y = (target.y|0) + event.dy;
          target.style.webkitTransform = target.style.transform = 'translate(' + target.x + 'px, ' + target.y + 'px)';
        },
        onend: function(event){
          var target = event.target;
          target.startX = startX;
          target.startY = startY;
          if(!Ember.$(target).hasClass('can-drop')){ // We only add can-drop when the draggable is over top of a dropzone
            this.moveBack(target);
          }
        }.bind(this)
      })
      .inertia(true);
  },

  clearPrompts: function(){
    this.get('messages').clear();
  },

  moveBack: function(element){
    element.x = element.startX;
    element.y = element.startY;
    element.style.webkitTransform = element.style.transform = 'translate(' + element.startX + 'px, ' + element.startY + 'px)';
  }

});


