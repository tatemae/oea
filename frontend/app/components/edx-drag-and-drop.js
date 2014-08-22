import Ember from 'ember';

export default Ember.Component.extend({

  didInsertElement: function(){

    interact('.dropzone')
      // enable draggables to be dropped into this
      .dropzone(true)
      // only accept elements matching this CSS selector
      .accept('.draggable')
      // listen for drop related events
      .on('dragenter', function (event) {
          var draggableElement = event.relatedTarget,
              dropzoneElement = event.target;

          // feedback the possibility of a drop
          dropzoneElement.classList.add('drop-target');
          draggableElement.classList.add('can-drop');
      })
      .on('dragleave', function (event) {
          // remove the drop feedback style
          event.target.classList.remove('drop-target');
          event.relatedTarget.classList.remove('can-drop');
      })
      .on('drop', function (event) {
          //event.relatedTarget.textContent = 'Dropped';
      });

    interact('.draggable')
      .draggable({
        onmove: function(event){
          //event.dataTransfer.setData('text/data', this.get('content.id'));
          var target = event.target;

          target.x = (target.x|0) + event.dx;
          target.y = (target.y|0) + event.dy;

          target.style.webkitTransform = target.style.transform =
              'translate(' + target.x + 'px, ' + target.y + 'px)';
        }
      })
      .inertia(true)
      .restrict({
        drag: this.$()[0]
      });
  }

});


