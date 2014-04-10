import Base from "./base";
import Qti from "../utils/qti";

var Answer = Base.extend({

  material: function(){
    return Qti.buildMaterial(this.get('xml').find('material').children());
  }.property('xml')

});

Answer.reopenClass({

  fromXml: function(xml){
    xml = $(xml);
    return Answer.create({
      'id': xml.attr('ident'),
      'xml': xml
    });
  },

  parseAnswers: function(xml){
    return Qti.listFromXml(xml, 'response_lid > render_choice > response_label', Answer);
  }

});

export default Answer;
