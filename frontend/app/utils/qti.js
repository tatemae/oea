import Ember from 'ember';

var Qti = {

  // Process nodes based on QTI spec here:
  // http://www.imsglobal.org/question/qtiv1p2/imsqti_litev1p2.html#1404782
  buildMaterial: function(nodes){
    var result = '';
    Ember.$.each(nodes, function(i, item){
      var parsedItem = Ember.$(item);
      switch(item.nodeName.toLowerCase()){
        case 'mattext':
          // TODO both mattext and matemtext have a number of attributes that can be used to display the contents
          result += parsedItem.text();
          break;
        case 'matemtext':
          // TODO figure out how to 'emphasize' text
          result += parsedItem.text();
          break;
        case 'matimage':
          result += '<img src="' + parsedItem.attr('uri') + '"';
          if(parsedItem.attr('label')) { result += 'alt="' + parsedItem.attr('label') + '"';   }
          if(parsedItem.attr('width')) { result += 'width="' + parsedItem.attr('width') + '"'; }
          if(parsedItem.attr('height')){ result += 'height="' + parsedItem.attr('height') + '"'; }
          result += ' />';
          break;
        case 'matref':
          var linkrefid = Ember.$(item).attr('linkrefid');
          // TODO figure out how to look up material based on linkrefid
          break;
      }
    });

    return result;
  },

  listFromXml: function(xml, selector, klass){
    xml = Ember.$(xml);
    var list = Ember.A();
    Ember.$.each(xml.find(selector), function(i, x){
      list.pushObject(klass.fromXml(x));
    });
    if(list.length <= 0 && klass.buildDefault){
      list.pushObject(klass.buildDefault(xml));
    }
    return list;
  }

};

export default Qti;
