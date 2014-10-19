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
      cssSrc: 'assets/css'
      imgSrc: 'assets/img'

      # static
      imgDst: 'static/img'
      fonts: 'static/fonts'
      cssDst: 'static/css'
      clientJS: 'static/js'
    }

  grunt.initConfig({
    paths: pathsConfig(),
    pkg: appConfig,
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
      img:
        expand: true
        cwd: '<%= paths.imgSrc %>'
        src: ['**']
        dest: '<%= paths.imgDst %>'
      css:
        expand: true
        cwd: '<%= paths.cssSrc %>'
        src: ['**']
        dest: '<%= paths.cssDst %>'
    serve:
      options:
        port: 3000,
        aliases:
          'static/css/app.css':
            tasks: ['copy:css'],
            output: './static/css/app.css'
          'static/js/app.js':
            tasks: ['coffee'],
            output: './static/js/app.js'
          'static/img/restart.svg':
            tasks: ['copy:img'],
            output: './static/img/restart.svg'
          '':
            tasks: [],
            output: './index.html'
  })

  grunt.registerTask('default', ['serve'])
