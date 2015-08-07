# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

controllers = angular.module('controllers')

controllers.controller 'UsersPartialController',
  class UsersPartialController
    @$inject = ['$scope', '$routeParams', '$location', '$http', '$rootScope', 'Api', 'UserAuth', '$window']

    requestAddFriend: (url) ->
      @$http.post(url, null,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @Api.loadUser(@$scope, @$scope.user.username)
      )
      .error( -> )

    requestRemoveFriend: (url) ->
      @$http.delete(url, null,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @Api.loadUser(@$scope, @$scope.user.username)
      )
      .error( -> )

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    constructor: (@$scope, $routeParams, @$location, @$http, $rootScope, @Api, UserAuth, @$window) ->
      user_id = $routeParams.user_id || UserAuth.getCurrentUser()?.username
      @bindCurrentUserToScope()
      @Api.loadUser(@$scope, user_id) if user_id

      $rootScope.$on('current_user:change', =>
        @bindCurrentUserToScope()
        @Api.loadUser(@$scope, UserAuth.getCurrentUser().username) if not $routeParams.user_id
      )

      @$scope.addFriend = =>
        url = "/json/users/#{@$scope.user.id}/friendships"
        @requestAddFriend(url)

      @$scope.removeFriend = =>
        url = "/json/users/#{@$scope.user.id}/friendships/1"
        @requestRemoveFriend(url)

      @$scope.friendshipsLink = =>
        @$location.path("/users/#{@$scope.current_user?.username}/friendships")
