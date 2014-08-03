TEMPLATEROOT = 'assets/tmpl/'
 
module.exports = (grunt) ->
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  appConfig = grunt.file.readJSON('package.json')

  pathsConfig = (appName)->
    @app = appName || appConfig.name

    return {
      app: @app
      # assets
      clientCoffee: 'assets/coffee'
      serverCoffee: 'server/'
      less: 'assets/less'
      temlatesSrc: TEMPLATEROOT
      testsSrc: 'assets/tests'
      imgSrc: 'assets/img'

      # static
      bower: 'static/components'
      clientJS: 'static/js'
      serverJS: 'server/'
      imgDst: 'static/img'
      fonts: 'static/fonts'
      css: 'static/css'
      temlatesDst: 'static/js/tmpl'
      testsDst: 'static/js/tests'
    }

  grunt.initConfig({
    paths: pathsConfig(),
    pkg: appConfig,
    handlebars:
      compile:
        options:
          amd: true
          processName: (name) ->
            console.log name
            TEMPLATEROOT = 'assets/tmpl/'
            return name.replace(TEMPLATEROOT, '').replace('.htm', '')
        src: ['<%= paths.temlatesSrc %>/**/*.htm']
        dest: '<%= paths.clientJS%>/templates.js'
    watch:
      grunt:
        files: ['Gruntfile.coffee']
      coffee:
        files: ['<%= paths.clientCoffee %>/**/*.coffee', '<%= paths.serverCoffee %>/**/*.coffee']
        tasks: ['coffee']
      less:
        files: ['<%= paths.less %>/**/*.less']
        tasks: ['less']
        options:
          nospawn: true
      handlebars:
        files: ['<%= paths.temlatesSrc %>/**',]
        tasks: ['handlebars']
        options:
          nospawn: true
      copy:
        files: ['<%= paths.imgSrc %>/**',]
        tasks: ['copy']
        options:
          nospawn: true
    bower:
      install:
        options:
          targetDir: '<%= paths.bower %>'
          layout: 'byComponent'
          #install: false
          verbose: false
          cleanTargetDir: true
          cleanBowerDir: false
          bowerOptions: {}
    less:
      development:
        options:
          paths: ['./assets/less'],
        files:
          {
            '<%= paths.css %>/app.css': '<%= paths.less %>/app.less',
          }
    coffee:
      client:
        options:
          bare: true
        expand: true
        flatten: false
        cwd: '<%= paths.clientCoffee%>'
        src: ['**/*.coffee']
        dest: '<%= paths.clientJS %>'
        ext: '.js'
    copy:
      templates:
        expand: true
        cwd: '<%= paths.temlatesSrc %>'
        src: ['**']
        dest: '<%= paths.temlatesDst %>'
      images:
        expand: true
        cwd: '<%= paths.imgSrc %>'
        src: ['**']
        dest: '<%= paths.imgDst %>'
      #server:
      #  options:
      #    bare: true
      #  expand: true
      #  flatten: false
      #  cwd: '<%= paths.serverCoffee %>'
      #  src: ['**/*.coffee']
      #  dest: '<%= paths.serverJS %>'
      #  ext: '.js'
 
    
  })
  grunt.registerTask('runApp', ()->require('./app'))

  grunt.registerTask('build', ['newer:coffee', 'newer:less', 'copy', 'handlebars'])
  grunt.registerTask('server', ['build', 'runApp','watch'])
  grunt.registerTask('default', ['server'])
