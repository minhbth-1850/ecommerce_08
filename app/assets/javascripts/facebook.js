(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s);
  js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.3&appId=2245166848870053&autoLogAppEvents=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk')); // Replace 'facebook-jssdk' with your page id.

// Compatibility with Turbolinks 5
(function($) {
  var fbRoot;

  function saveFacebookRoot() {
    if ($('#fb-root').length) {
      fbRoot = $('#fb-root').detach();
    }
  };

  function restoreFacebookRoot() {
    if (fbRoot != null) {
      if ($('#fb-root').length) {
        $('#fb-root').replaceWith(fbRoot);
      } else {
        $('body').append(fbRoot);
      }
    }

    if (typeof FB !== "undefined" && FB !== null) { // Instance of FacebookSDK
      FB.XFBML.parse();
    }
  };

  document.addEventListener('turbolinks:request-start', saveFacebookRoot)
  document.addEventListener('turbolinks:load', restoreFacebookRoot)
}(jQuery));
