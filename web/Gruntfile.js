module.exports = function(grunt) {
  grunt.initConfig({
    jshint: {
      files: ['Gruntfile.js', 'muve-photos.js']
    },
    uglify: {
      options: {

      },
      my_target: {
        files: {
          'muve-photos.min.js': ['tabletop.js', 'muve-photos.js']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.registerTask('default', ['jshint', 'uglify']);
};
