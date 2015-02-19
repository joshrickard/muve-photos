
(function() {

  var muvePhotos = {
    currentPage: 0,
    photosPerPage: 3,
    options: { },
    photos: [ ],

    init: function(config) {
      muvePhotos.options = config || { };

	    window.onload = function() {
		    Tabletop.init({
			    key: config.key,
			    callback: function(data, tabletop) {
            muvePhotos.showInfo(data, config.hashtag);
          },
			    simpleSheet: true
		    });
	    };
    },

    previousPage: function() {
      if (muvePhotos.currentPage > 0) {
        muvePhotos.currentPage--;
        muvePhotos.renderPage();
      }
    },

    nextPage: function() {
      if (muvePhotos.photos.length > ((muvePhotos.currentPage + 1) * muvePhotos.photosPerPage)) {
        muvePhotos.currentPage++;
        muvePhotos.renderPage();
      }
    },

    renderPage: function() {
      for (var i = 0; i < 3; i++) {
        var index = muvePhotos.currentPage * muvePhotos.photosPerPage + i;
        var link = document.getElementById('muve_photo_a_' + i);
        var img = document.getElementById('muve_photo_i_' + i);

        if (index < muvePhotos.photos.length) {
          link.href = muvePhotos.photos[index];
          link.style.display = '';
          img.src = muvePhotos.photos[index];
        } else {
          link.href = '';
          link.style.display = 'none';
          img.src = '';
        }
      }
    },

    showInfo: function(data, hashtag) {
      var container = document.getElementById( muvePhotos.options.container );
      var i = 0;

      for (i = 0; i < 3; i++) {
        container.innerHTML = container.innerHTML +
          "<a href='' id='muve_photo_a_" + i + "' target='_blank'>" +
            "<img class='" + muvePhotos.options.classes + "' id='muve_photo_i_" + i + "' style='" + muvePhotos.options.styles + "' src=''>" +
          "</a>";
      }

      container.innerHTML = container.innerHTML +
        "<div class='controls'>" +
          "<a href='#' onclick='MuvePhotos.previousPage(); return false' style='color: black;'>Previous</a>" +
          " &#8212; " +
          "<a href='#' onclick='MuvePhotos.nextPage(); return false' style='color: black;'>Next</a>" +
        "</div>";

		  for (i = 0; i < data.length; i++) {

			  // make sure the approved, hashtag, and mediaurl attributes are populated
			  if (! ("approved" in data[i]) || (! data[i].approved)) continue;
			  if (! ("hashtag" in data[i]) || (! data[i].hashtag)) continue;
			  if (! ("mediaurl" in data[i]) || (! data[i].mediaurl)) continue;

			  // only display the image if it is approved
			  if ((data[i].approved.toLowerCase() === "yes") && (data[i].hashtag.toLowerCase() === hashtag)) {
          muvePhotos.photos.push( data[i].mediaurl );
			  }
		  }

      muvePhotos.renderPage();
    }

  };

  window.MuvePhotos = muvePhotos;

})();

