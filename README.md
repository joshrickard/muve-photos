Summary
=======

This project was originally created to aggregate social media photos for the [Museum Volunteers for the Environment](http://www.miamisci.org/muve/).


How does it work?
=================

There are two components to this solution: a scheduled Ruby script and a Javascript snippet.

The Ruby script performs a search on Twitter, Instagram and Flickr for photos that are tagged with a specific hashtag.  As new photos are discovered they are tracked in a Google spreadsheet.  An administrator can then flag each photo as "approved" at which point it can be displayed on your website.

A Javascript snippet is used to embed the photos on your website.  The script will load the approved images from the Google spreadsheet and then dynamically inserts the photos into your webpage.


Website Integration
===================

Step 1) Add this script to your web page:

    <script type="text/javascript" src="//cdn.rawgit.com/joshrickard/muve-photos/master/web/muve-photos.min.js"></script>

This will include a small javascript library that enables step 2.


Step 2) Add a container element to the page.  Place it wherever you want the photos to show up.  Somewhere after the container element, add the javascript snippet below:

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

Parameters

* container - the id of the html element that will receive the photos
* key - this is the Google spreadsheet key
* hashtag - photos in the Google spreadsheet with this hashtag will be displayed
* styles - inline styles (optional)
* classes - css class(es) for the image tags (optional)


Scheduled Ruby Script
=====================

The Ruby script connects to the social media sites, executes searches to find photos with the desired hashtag, and then saves the results in a Google spreadsheet.

Step 1) Setup a functioning Ruby installation (tested against 2.1.5p273)

Step 2) [Download and extract](https://github.com/joshrickard/muve-photos/archive/master.zip) the code to a directory of your choice

Step 3) cd into the aggregator directory and execute `bundle install` to install dependencies

Step 4) Copy the aggregator/config.example.yml to aggregator/config.yml

Step 5) Fill in all of the parameters in aggregator/config.yml - you will need to have accounts on all of the social media sites and go through the process of obtaining development keys

Step 6) Create a Google spreadsheet with the following columns: source, id, created, hashtag, url, media_url, approved?  [See here for an example](https://docs.google.com/spreadsheets/d/1N4BTn6knwNNNU8bC4l0ZtDVEB2uBPZ0zNgct2KwNxxI/pubhtml).

Step 7) Publish the Google spreadsheet to the web to make it read only to our javascript

Step 7) Setup a scheduled task to execute aggregator/harvest.rb on a regular basis