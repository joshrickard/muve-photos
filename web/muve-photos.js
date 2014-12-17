
(function() {

  var muve_photos = {
    options: { },

    init: function(config) {
      muve_photos.options = config || { };

	    window.onload = function() {
		    Tabletop.init({
			    key: config.key,
			    callback: function(data, tabletop) {
            muve_photos.showInfo(data, config.hashtag);
          },
			    simpleSheet: true
		    });
	    };
    },

    showInfo: function(data, hashtag) {
      var container = document.getElementById( muve_photos.options.container );

		  for (var i = 0; i < data.length; i++) {

			  // make sure the approved, hashtag, and mediaurl attributes are populated
			  if (! ("approved" in data[i]) || (! data[i].approved)) continue;
			  if (! ("hashtag" in data[i]) || (! data[i].hashtag)) continue;
			  if (! ("mediaurl" in data[i]) || (! data[i].mediaurl)) continue;

			  // only display the image if it is approved
			  if ((data[i].approved.toLowerCase() === "yes") && (data[i].hashtag.toLowerCase() === hashtag)) {
          container.innerHTML = container.innerHTML +
            "<a href='" + data[i].mediaurl + "' target='_blank'>" +
              "<img class='" + muve_photos.options.classes + "' style='" + muve_photos.options.styles + "' src='" + data[i].mediaurl + "'>" +
            "</a>";
			  }
		  }
    }

  };

  window.MuvePhotos = muve_photos;

})();

