var Qti = {

  // Process nodes based on QTI spec here:
  // http://www.imsglobal.org/question/qtiv1p2/imsqti_litev1p2.html#1404782
  buildMaterial: function(nodes){
    var result = '';
    $.each(nodes, function(i, item){
      var $item = $(item);
      switch(item.nodeName.toLowerCase()){
        case 'mattext':
          // TODO both mattext and matemtext have a number of attributes that can be used to display the contents
          result += $item.text();
          break;
        case 'matemtext':
          // TODO figure out how to 'emphasize' text
          result += $item.text();
          break;
        case 'matimage':
          result += '<img src="' + $item.attr('uri') + '"';
          if($item.attr('label')) { result += 'alt="' + $item.attr('label') + '"';   }
          if($item.attr('width')) { result += 'width="' + $item.attr('width') + '"'; }
          if($item.attr('height')){ result += 'height="' + $item.attr('height') + '"'; }
          result += ' />';
          break;
        case 'matref':
          var linkrefid = $(item).attr('linkrefid');
          // TODO figure out how to look up material based on linkrefid
          break;
      }
    });

    return result;
  },

  listFromXml: function(xml, selector, klass){
    xml = $(xml);
    var list = Ember.A();
    $.each(xml.find(selector), function(i, x){
      list.pushObject(klass.fromXml(x));
    });
    if(list.length <= 0 && klass.buildDefault){
      list.pushObject(klass.buildDefault(xml));
    }
    return list;
  }

};

export default Qti;
