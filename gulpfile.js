'use strict';

var gulp = require('gulp');
var coffee = require('gulp-coffee')
var gutil = require('gulp-util')
var sourcemaps = require('gulp-sourcemaps')
var del = require('del');

gulp.task('clean-dist', function (cb) {
  del('dist/', cb);
});

gulp.task('dist', ['clean-dist'], function() {
  gulp.src('src/**/*.coffee')
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('dist/'));
});

gulp.task('coffee', function() {
  gulp.src('src/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee().on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('.tmp/dist/'));
});

gulp.task('coffee-spec', function() {
  gulp.src('test/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee().on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('.tmp/test/'));
});

gulp.task('build', ['coffee','coffee-spec','dist']);

gulp.task('default', ['build'], function () {
  gulp.watch('src/**/*.coffee', ['coffee','dist']);
  gulp.watch('test/**/*.coffee', ['coffee-spec']);
});
