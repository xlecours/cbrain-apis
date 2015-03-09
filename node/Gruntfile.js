module.exports = function(grunt) {
  
  // Project configuration.
  grunt.initConfig({
   
    pkg: grunt.file.readJSON('package.json'),
     
    docular: {
      docular_webapp_target: "docs/docular",
      docular_partial_home: "docs/node_api_home.html",
      groups: [
        {
          groupTitle: "Node API",
          groupId: "node API",
          showSource: false,
          sections: [
            {
              title: "Node API",
              id: "node API",
              scripts: ["lib/cbrain_api.js"]
            },
          ],
        },
      ],
    },
  });
     
  // Load the plugin that provides the "docular" tasks.
  grunt.loadNpmTasks('grunt-docular');
   
  // Default task(s).
  grunt.registerTask('default', ['docular']);
     
};
