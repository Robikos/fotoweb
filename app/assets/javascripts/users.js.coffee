# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

controllers = angular.module('controllers')

controllers.controller 'UsersController',
  class UsersController
    @$inject = ['$scope', '$routeParams', '$location', '$http', '$window', '$rootScope', 'Api']

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    showPost: (id) ->
      @$rootScope.$broadcast('post_modal:show', user_id: @$routeParams.user_id, post_id: id)

    constructor: (@$scope, @$routeParams, @$location, @$http, @$window, @$rootScope, Api) ->
      @bindCurrentUserToScope()
      Api.loadUserPosts(@$scope, @$routeParams.user_id)

      @$rootScope.$on('current_user:change', => @bindCurrentUserToScope())

      @$scope.showLink = (id) =>
        @showPost(id)

      @$scope.addPostLink = ->
        console.log("addpostlink")
        @$location.path("/users/#{@$scope.current_user.username}/posts/new")

      @$scope.friendshipsLink = ->
        @$location.path("/users/#{@$scope.current_user.username}/friendships")

controllers.controller 'CurrentUserController',
  class CurrentUserController
    @$inject = ['$scope', '$routeParams', '$location', '$http', '$window', 'Api', 'UserAuth', '$rootScope']

    requestAddFriend = (user_id, url) ->
      fd = new FormData()
      fd.append('user_id', user_id)
      @$http.post(url, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( ->
        @$scope.friendshipsLink()
      )
      .error( -> )

    showPost: (id) ->
      @$rootScope.$broadcast('post_modal:show', user_id: @$window.current_user.username, post_id: id)

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    constructor: (@$scope, $routeParams, @$location, @$http, @$window, Api, UserAuth, @$rootScope) ->
      @bindCurrentUserToScope()
      Api.loadUserPosts(@$scope, UserAuth.getCurrentUser().username) if UserAuth.getCurrentUser()

      @$rootScope.$on('current_user:change', =>
        @bindCurrentUserToScope()
        Api.loadUserPosts(@$scope, UserAuth.getCurrentUser().username) if UserAuth.getCurrentUser()        
      )

      @$scope.showLink = (id) =>
        @showPost(id)

      @$scope.addPostLink = ->
        console.log("addpostlink")
        @$location.path("/users/#{$scope.current_user.username}/posts/new")

      @$scope.friendshipsLink = ->
        @$location.path("/users/#{$scope.current_user.username}/friendships")

      @$scope.closeDialog = ->
        @$scope.post_show = false
