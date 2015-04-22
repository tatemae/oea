var MathJaxInit = {
  /* insert the MathJax script dynamically into the document */
  /* also insert a fix for Google+, until fixed upstream in MathJax */
  /* copied from https://github.com/christianp/mathjax-bookmarklet/blob/master/wordpress.js */
  insertScript: function (doc) {

    var googleFix = '.MathJax .mn {background: inherit;} .MathJax .mi {color: inherit;} .MathJax .mo {background: inherit;}';
    var style=doc.createElement('style');
    style.innerText = googleFix;
    try {
      style.textContent = googleFix;
    }catch(e) {}
    doc.getElementsByTagName('body')[0].appendChild(style);

    var script = doc.createElement('script'), config;

    /* see http://www.mathjax.org/resources/faqs/#problem-https */
    // script.src = 'http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_HTMLorMML.js';
    script.src = '/MathJax/MathJax.js?config=TeX-MML-AM_HTMLorMML.js';
    script.type = 'text/javascript';

    /* see http://www.mathjax.org/docs/1.1/options/tex2jax.html */
    config = 'MathJax.Hub.Config({tex2jax:{inlineMath:[[\'$\',\'$\'], ["\\(","\\)"]],displayMath:[[\'\\\\[\',\'\\\\]\'], ["\\[","\\]"]],processEscapes:true}});MathJax.Hub.Startup.onload();';



// MathJax.Hub.Config({
//     extensions: ["tex2jax.js"],
//     jax: ["input/TeX", "output/HTML-CSS"],
//     tex2jax: {
//       inlineMath: [ ['$','$'], ["\\(","\\)"] ],
//       displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
//       processEscapes: true
//     },
//     "HTML-CSS": { availableFonts: ["TeX"] }
//   });



    if (window.opera) script.innerHTML = config; else script.text = config;

    doc.getElementsByTagName('head')[0].appendChild(script);
  },

  /* execute MathJax for given window */
  executeMathJax: function (win) {

    function replaceImageLaTeX(img) {
      if(img.tagName!='IMG')
        return;
      // img.setAttribute('alt', "$$" + img.getAttribute('alt') + "$$");
      var span = win.document.createElement('span');
      span.setAttribute('class','MathJax_Preview');
      var script = win.document.createElement('script');
      script.setAttribute('type','math/tex');
      script.innerText = img.getAttribute('alt');
      var parentElement = img.parentElement;
      parentElement.replaceChild(script,img);
      span.appendChild(img);
      parentElement.insertBefore(span,script);
    }

    var maths=win.document.getElementsByClassName('equation_image');
    for(var i=0;i<maths.length;i++) {
      replaceImageLaTeX(maths[i]);
    }

    maths=win.document.getElementsByClassName('latex');
    for(var i=0;i<maths.length;i++) {
      replaceImageLaTeX(maths[i]);
    }

    maths=win.document.getElementsByClassName('tex');
    for(var i=0;i<maths.length;i++) {
      replaceImageLaTeX(maths[i]);
    }

    if (win.MathJax === undefined) {
        /* insert the script into document if MathJax global doesn't exist for given window */
        this.insertScript(win.document);
    } else {
        /* using win.Array instead of [] to get 'instanceof Array' check working inside iframe */
        /* see http://www.mathjax.org/docs/1.1/typeset.html */
        win.MathJax.Hub.Queue(new win.Array('Typeset', win.MathJax.Hub));
    }
  }
};

export default MathJaxInit;
