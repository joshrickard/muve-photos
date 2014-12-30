muve-photos
===========

Aggregates photos from social media sites for the Museum Volunteers for the Environment.  The photo urls are loaded into a google spreadsheet which are then manually approved.  After being approved they can be displayed on a website by using the code snippets below.

http://www.miamisci.org/muve/


Installation
============

Step 1) Add this script to your web page:

    <script type="text/javascript" src="http://rawgit.com/joshrickard/muve-photos/master/web/muve-photos.min.js"></script>


Step 2) Add a container element and call the init function.  The key is

    <div id="photos"></div>
    <script type="text/javascript">
      MuvePhotos.init({
        container: "photos",
        key: "1N4BTn6knwNNNU8bC4l0ZtDVEB2uBPZ0zNgct2KwNxxI",
        hashtag: "vknp1",
        styles: "padding: 4px; width: 250px; height: 250px;",
        classes: "muve-photo"
      });
    </script>
