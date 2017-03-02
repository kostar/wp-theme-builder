app          = {}
app.name     = theme.name # Application name
app.desc     = theme.desc # This is my application
app.url      = "localhost" # Homepage link
app.devName  = theme.author # Developer name (Company name)
app.devURL   = theme.authorUrl # Developer URL (Company URL)

###
# Default paths
###
TODAY = new Date();
DD    = TODAY.getDate();
if 10 > DD
  DD = '0' + DD
MM    = TODAY.getMonth()+1;
if 10 > MM
  MM = '0' + MM
YYYY  = TODAY.getFullYear();
THEME_NAME = 'wp_'+ theme.slug + '_' + YYYY + '-' + MM + '-' + DD + '_build-' + Date.now()
path         = {}
path.temp    = './temp'
path.source  = './source'
path.build   = './build'
path.release = './release'
path.dev     = './dev' # /wp-content/themes
csso_options = {restructure: false, sourceMap: true, debug: true}
THEME_PATH   = path.dev

###
# General requires
###
gulp         = require('gulp')
runSequence  = require('run-sequence')
Notification = require('node-notifier')
$ = require('gulp-load-plugins')(
  pattern: [
    'gulp-*'
    'gulp.*'
  ]
  replaceString: /\bgulp[\-.]/)

gulp.task 'default', [ 'test' ]

###
# Initial project
###
gulp.task 'init', (callback) ->
  runSequence [
    'init_favicons'
    'init_php'
    'init_js'
    'init_styles'
    'init_styles_normalize'
    'init_screenshot'
    'init_lang'
    'init_others'
  ], callback

gulp.task 'init_favicons', ->
  gulp.src("./include/logo.png")
    .pipe($.favicons({
        appName: app.name
        appDescription: app.desc
        developerName: app.devName
        developerURL: app.devURL
        background: "#020307"
        path: "favicons/"
        url: app.url
        display: "standalone"
        orientation: "portrait"
        start_url: "/?homescreen=1"
        version: 1.0
        logging: false
        online: false
        html: "favicons.html"
        pipeHTML: true
        replace: true
    }))
    .on('error', errorHandler('Favicons generator'))
    .pipe(gulp.dest(path.source+'/favicons'));

gulp.task 'init_php', ->
  gulp.src('./include/_s/**/*.php')
    .pipe($.replace('\'_s\'', '\''+theme.slug+'\''))
    .pipe($.replace('_s_', theme.slug_s+'_'))
    .pipe($.replace('_s', theme.name_s))
    .pipe($.replace('_s-', theme.slug+'-'))
    .pipe gulp.dest(path.source+'/php/')

gulp.task 'init_js', ->
  gulp.src('./include/_s/js/**/*.js')
    .pipe($.replace('\'_s\'', '\''+theme.slug+'\''))
    .pipe($.replace('_s_', theme.slug_s+'_'))
    .pipe($.replace('_s', theme.name_s))
    .pipe($.replace('_s-', theme.slug+'-'))
    .pipe gulp.dest(path.source+'/scripts/')

gulp.task 'init_styles', ->
  gulp.src('./include/_s/sass/**/*.scss')
    .pipe($.replace('\'_s\'', '\''+theme.slug+'\''))
    .pipe($.replace('_s_', theme.slug_s+'_'))
    .pipe($.replace('_s', theme.name_s))
    .pipe($.replace('_s-', theme.slug+'-'))
    .pipe gulp.dest(path.source+'/styles/')

gulp.task 'init_styles_normalize', ->
  gulp.src('./include/normalize/**/*.scss')
    .pipe gulp.dest(path.source+'/styles/')

gulp.task 'init_screenshot', ->
  gulp.src('./include/screenshot.{png,xcf}')
    .pipe gulp.dest(path.source)

gulp.task 'init_lang', ->
  gulp.src('./include/_s/languages/_s.pot')
    .pipe($.replace('_s', theme.name_s))
    .pipe($.rename(theme.slug+'.pot'))
    .pipe gulp.dest(path.source+'/others/languages/')

gulp.task 'init_others', ->
  gulp.src(['./include/_s/languages*/readme.txt', './include/_s/layouts*/*', './include/_s/LICENSE', './include/_s/README.md', './include/_s/.jscsrc', './include/_s/.jshintignore', './include/_s/.travis.yml', './include/_s/CONTRIBUTING.md', './include/_s/codesniffer.ruleset.xml', './include/_s/rtl.css', './include/_s/readme.txt'])
    .pipe gulp.dest(path.source+'/others/')

###
# Regular tasks
###
gulp.task 'dev', (callback) ->
  THEME_PATH = path.dev+'/'+theme.slug
  runSequence [
    'clean_temp_folder'
    'clean_theme_folder'
  ], [
    'copy_screenshot'
    'copy_favicons'
    'copy_fonts'
    'copy_images'
    'copy_php'
    'styles'
    'scripts'
  ], 'watch', callback

gulp.task 'build', (callback) ->
  THEME_PATH = path.build+'/'+theme.slug
  csso_options = ''
  runSequence [
    'clean_temp_folder'
    'clean_theme_folder'
  ], [
    'copy_screenshot'
    'copy_favicons'
    'copy_fonts'
    'copy_images'
    'copy_php'
    'styles'
    'scripts'
  ], 'zip', callback


###
# Tasks
###
gulp.task 'styles', (callback) ->
  runSequence [
    'clean_temp_css_folder'
    'styles_scss'
    ],
    'styles_merge'
    callback

gulp.task 'styles_scss', ->
  gulp.src(path.source+'/styles/style.scss')
      .pipe($.sass(errLogToConsole: true).on('error', errorHandler('SASS')))
      .pipe($.autoprefixer('last 2 version'))
      .pipe($.stripCssComments(preserve: false))
      .pipe($.csso(csso_options))
      .pipe gulp.dest('./temp/css/')

gulp.task 'styles_merge', ->
  gulp.src([
        path.source+'/style.css'
        './temp/css/style.css'
      ])
      .pipe($.concat('style.css')).pipe gulp.dest(THEME_PATH + '/')

gulp.task 'test', ->
  Notification.notify
    title: '!!! Test task for example !!!'
    message: 'All done!\nPlease check result!'
    icon: __dirname+'/include/reatlat.png'

gulp.task 'done', ->
  Notification.notify
    title: 'Congrats!'
    message: 'All done!\nPlease check result!'
    icon: __dirname+'/include/reatlat.png'

gulp.task 'watch', ->
  # Watch all files - *.coffee, *.js and *.scss
  console.log ''
  console.log '  May the Force be with you'
  console.log ''
  gulp.watch path.source+'/favicons/**/*', [ 'copy_favicons' ]
  gulp.watch path.source+'/fonts/**/*', [ 'copy_fonts' ]
  gulp.watch path.source+'/scripts/**/*.{coffee,js}', [ 'scripts' ]
  gulp.watch path.source+'/styles/**/*.scss', [ 'styles' ]
  gulp.watch path.source+'/style.css', [ 'styles' ]
  gulp.watch path.source+'/php/**/*.php', [ 'copy_php' ]

gulp.task 'clean_temp_folder', ->
  gulp.src(path.temp, read: false)
      .pipe $.clean()

gulp.task 'clean_temp_css_folder', ->
  gulp.src(path.temp+'/css', read: false)
      .pipe $.clean()

gulp.task 'clean_theme_folder', ->
  gulp.src(THEME_PATH+'/*', read: false)
      .pipe $.clean(force: true)

gulp.task 'scripts', (callback) ->
  runSequence [
    'coffeeScripts'
    'javaScripts'
    ], callback

gulp.task 'coffeeScripts', ->
  gulp.src(path.source+'/scripts/!(_)*.coffee')
      .pipe($.include(extension: '.coffee').on('error', errorHandler('Include *.coffee')))
      .pipe($.coffee(bare: true).on('error', errorHandler('CoffeeScript')))
      .pipe($.uglify({}))
      .pipe gulp.dest(THEME_PATH+'/js/')

gulp.task 'javaScripts', ->
  gulp.src(path.source+'/scripts/*.js')
      .pipe($.include(extension: '.js').on('error', errorHandler('Include *.js')))
      .pipe($.uglify({}))
      .pipe gulp.dest(THEME_PATH+'/js/')

gulp.task 'javaScripts_vendor', ->
  gulp.src(path.source+'/scripts/vendor/**/*.js')
      .pipe($.changed(THEME_PATH+'/js/vendor/'))
      .pipe gulp.dest(THEME_PATH+'/js/vendor/')

gulp.task 'copy_screenshot', ->
  gulp.src(path.source+'/screenshot.png')
      .pipe($.changed(THEME_PATH))
      .pipe gulp.dest(THEME_PATH)

gulp.task 'copy_favicons', ->
  gulp.src(path.source+'/favicons/**/*')
      .pipe($.changed(THEME_PATH+'/favicons/'))
      .pipe gulp.dest(THEME_PATH+'/favicons/')

gulp.task 'copy_fonts', ->
  gulp.src(path.source+'/fonts/**/*')
      .pipe($.changed(THEME_PATH+'/fonts/'))
      .pipe gulp.dest(THEME_PATH+'/fonts/')

gulp.task 'copy_images', ->
  gulp.src(path.source+'/images/**/*.{jpg,JPG,png,PNG,gif,GIF,svg,SVG}')
      .pipe($.changed(THEME_PATH+'/images/'))
      .pipe gulp.dest(THEME_PATH+'/images/')

gulp.task 'copy_php', ->
  gulp.src(path.source+'/php/**/*.php')
      .pipe($.changed(THEME_PATH+'/'))
      .pipe gulp.dest(THEME_PATH+'/')

gulp.task 'zip', ->
  gulp.src(THEME_PATH+'*/**')
      .pipe($.archiver(THEME_NAME+'.zip').on('error', errorHandler('ZIP Compression')))
      .pipe($.notify(
        title: 'WP Theme builder'
        message: 'Theme already archived to zip file'
        icon: __dirname+'/include/reatlat.png'))
      .pipe gulp.dest(path.release)


###
# Helpers
###
errorHandler = (title) ->
  (error) ->
    $.util.log $.util.colors.yellow(error.message)
    Notification.notify
      title: title
      message: error.message
      icon: __dirname+'/include/reatlat.png'
    @emit 'end'
