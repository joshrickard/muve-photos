
(function() {

  var muvePhotos = {
    currentPage: 0,
    photosPerPage: 1,
    options: { },
    photos: [ ],
    rotationDelay: 5000,

    init: function(config) {
      muvePhotos.options = config || { };

	    window.onload = function() {
		    Tabletop.init({
			    key: config.key,
			    callback: function(data, tabletop) {
            var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

            for (var i = 0; i<data.length; i++) {
              var d = new Date( data[i].created.substr(0, 10) );
              data[i].created_date = monthNames[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear();
              data[i].created_parsed = d;
            }

            data.sort( function(a, b) {
              if (a.created_parsed < b.created_parsed)
                return -1;
              if (a.created_parsed > b.created_parsed)
                return 1;
              return 0;
            });

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
      for (var i = 0; i < muvePhotos.photosPerPage; i++) {
        var index = muvePhotos.currentPage * muvePhotos.photosPerPage + i;
        var link = document.getElementById('muve_photo_a_' + i);
        var img = document.getElementById('muve_photo_i_' + i);
        var caption = document.getElementById('muve_photo_c_' + i);

        if (index < muvePhotos.photos.length) {
          link.href = muvePhotos.photos[index].mediaurl;
          link.style.display = '';
          img.src = muvePhotos.photos[index].mediaurl;
          caption.innerHTML = muvePhotos.photos[index].created_date;
        } else {
          link.href = '';
          link.style.display = 'none';
          img.src = '';
          caption.innerHTML = '';
        }
      }
    },

    rotate: function() {
      (function(){
        muvePhotos.currentPage += 1;
        if (muvePhotos.currentPage > muvePhotos.photos.length - 1)
          muvePhotos.currentPage = 0;

        muvePhotos.renderPage();

        setTimeout(arguments.callee, muvePhotos.rotationDelay);
      })();
    },

    showInfo: function(data, hashtag) {
      var container = document.getElementById( muvePhotos.options.container );
      var i = 0;

      for (i = 0; i < muvePhotos.photosPerPage; i++) {
        container.innerHTML = container.innerHTML +
          "<a href='' id='muve_photo_a_" + i + "' target='_blank'>" +
            "<img class='" + muvePhotos.options.classes + "' id='muve_photo_i_" + i + "' style='" + muvePhotos.options.styles + "' src=''>" +
          "</a>" +
          "<div id='muve_photo_c_" + i + "' style='padding-left: 4px;'></div>";
      }

      // container.innerHTML = container.innerHTML +
      //   "<div class='controls'>" +
      //     "<a href='#' onclick='MuvePhotos.previousPage(); return false' style='color: black;'>Previous</a>" +
      //     " &#8212; " +
      //     "<a href='#' onclick='MuvePhotos.nextPage(); return false' style='color: black;'>Next</a>" +
      //   "</div>";

		  for (i = 0; i < data.length; i++) {

			  // make sure the approved, hashtag, and mediaurl attributes are populated
			  if (! ("approved" in data[i]) || (! data[i].approved)) continue;
			  if (! ("hashtag" in data[i]) || (! data[i].hashtag)) continue;
			  if (! ("mediaurl" in data[i]) || (! data[i].mediaurl)) continue;

			  // only display the image if it is approved
			  if ((data[i].approved.toLowerCase() === "yes") && (data[i].hashtag.toLowerCase() === hashtag)) {
          muvePhotos.photos.push( data[i] );
			  }
		  }

      muvePhotos.renderPage();

      setTimeout(muvePhotos.rotate, muvePhotos.rotationDelay);
    }

  };

  window.MuvePhotos = muvePhotos;

})();

