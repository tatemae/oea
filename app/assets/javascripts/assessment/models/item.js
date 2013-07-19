var ModelBase = require('./model_base');
var Answer = require('./answer');

var Item = ModelBase.extend({

  answers: function(){
    return Answer.list_from_xml(this.xml);
    // var model = this;
    // return new Ember.RSVP.Promise(function(resolve, reject){
    //   return resolve(Answer.list_from_xml(model.xml));
    // });
  }

});

Item.reopenClass({

  find: function(items, item_id){
    return new Ember.RSVP.Promise(function(resolve, reject){
      items.then(function(items){
        var item = items.find(function(item, index, enumerable){
          if(item.id == item_id){
            return item;
          }
        });
        if(item){
          resolve(item);
        } else {
          reject('No item found with id: ' + item_id);
        }
      });
    });
  },

  from_xml: function(xml){
    xml = $(xml);
    return Item.create({
      id: xml.attr('ident'),
      title: xml.attr('title'),
      xml: xml
    });
  },

  list_from_xml: function(xml){
    return this._list_from_xml(xml, 'item', Item);
  }

});

module.exports = Item;