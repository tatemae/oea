var App = require('./app');

App.Router.map(function(){
  // this.route('assessments');
  // this.route('assessment', { path:  '/assessment/:assessment_id' });
  // this.route('sections', { path: '/assessment/:assessment_id/sections' });
  // this.route('section', { path: '/assessment/:assessment_id/sections/:section_id' });
  // this.route('items', { path: '/assessment/:assessment_id/sections/:section_id/items' });
  // this.route('item', { path: '/assessment/:assessment_id/sections/:section_id/items/:item_id' });

  this.resource('assessments');
  this.resource('assessment',   { path: '/assessment/:assessment_id' }, function(){
    this.resource('sections');
    this.resource('section',    { path: '/section/:section_id' },         function(){
      this.resource('items');
      this.resource('item',     { path: '/item/:item_id' });
    });
  });

  // this.resource('assessments');
  // this.resource('assessment',   { path: 'assessment/:assessment_id' }, function(){
  //   this.resource('sections',                                          function(){
  //     this.resource('section',  { path: 'section/:section_id' },       function(){
  //       this.resource('items',                                         function(){
  //         this.resource('item', { path: 'item/:item_id' });
  //       });
  //     });
  //   });
  // });

});


// App.Router.map(function() {
//   this.resource("posts", { path: "/" }, function() {
//     this.resource("post", { path: "/:post_id" }, function() {
//       this.resource("comments", { path: "/comments" }, function() {
//         this.resource("comment", { path: "/:comment_id" }, function() {
//           this.route("edit", { path: "/edit" });
//         });
//       });
//     });
//   });
// });