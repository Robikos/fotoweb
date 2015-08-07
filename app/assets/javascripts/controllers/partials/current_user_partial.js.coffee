# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

controllers = angular.module('controllers')

controllers.controller 'CurrentUserPartialController',
  class CurrentUserPartialController
    @$inject = ['$scope', '$routeParams', '$location', '$http', '$window', 'UserAuth', '$rootScope']

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    constructor: (@$scope, $routeParams, $location, $http, @$window, UserAuth, @$rootScope) ->
      UserAuth.getCurrentUser()
      @bindCurrentUserToScope()

      @$rootScope.$on('current_user:change', => @bindCurrentUserToScope())

      @$scope.addPostLink = =>
        $location.path("/users/#{@$scope.current_user.username}/posts/new")

      @$scope.friendshipsLink = =>
        $location.path("/users/#{@$scope.current_user.username}/friendships")

      @$scope.addPhotoLink = ->
        
