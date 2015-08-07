# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

controllers = angular.module('controllers')

controllers.controller 'PostController',
  class PostController
    @$inject = ['$scope', '$routeParams', '$location', '$http', 'Api', '$rootScope']

    postLikeRequest: (url) ->
      fd = new FormData()
      fd.append('post_id', @$scope.post_id)
      @$http.post(url, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @Api.loadPost(@$scope, @$scope.user_id, @$scope.post_id)
      )
      .error( -> )

    postCommentRequest: (url, text) ->
      fd = new FormData()
      fd.append('post_id', @$scope.post_id)
      fd.append('comment[text]', text)
      @$http.post(url, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @Api.loadPost(@$scope, @$scope.user_id, @$scope.post_id)
      )
      .error( -> )      

    deleteUnlikeRequest: (url) ->
      fd = new FormData()
      fd.append('post_id', @$scope.post_id)
      @$http.delete(url, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @Api.loadPost(@$scope, @$scope.user_id, @$scope.post_id) 
      )
      .error( -> )

    constructor: (@$scope, $routeParams, $location, @$http, @Api, $rootScope) ->
      @$scope.post_show = false

      $rootScope.$on 'post_modal:show', (broadcast, args) =>
        @Api.loadPost(@$scope, args.user_id, args.post_id)
        @$scope.post_show = true
        @$scope.user_id = args.user_id
        @$scope.post_id = args.post_id

      @$scope.addComment = =>
        url = "/json/users/#{@$scope.user_id}/posts/#{@$scope.post_id}/comments"
        @postCommentRequest(url, @$scope.new_comment_body)
        @$scope.new_comment_body = ""

      @$scope.closeDialog = => @$scope.post_show = false

      @$scope.likeButton = =>
        url = "/json/users/#{@$scope.user_id}/posts/#{@$scope.post_id}/likes"
        @postLikeRequest(url, @$scope.post_id)

      @$scope.unlikeButton = =>
        url = "/json/users/#{@$scope.user_id}/posts/#{@$scope.post_id}/likes/1"
        @deleteUnlikeRequest(url, @$scope.post_id)

      @$scope.previousLink = =>
        $rootScope.$broadcast('post_modal:show',
          user_id: @$scope.user_id,
          post_id: @$scope.prev_id
        )

      @$scope.nextLink = =>
        $rootScope.$broadcast('post_modal:show',
          user_id: @$scope.user_id,
          post_id: @$scope.next_id
        )        

controllers.controller 'NewPostController',
  class NewPostController
    @$inject = ['$scope', '$location', '$http', '$window', '$rootScope']

    uploadFileToUrl: (post, uploadUrl) ->
      fd = new FormData()
      fd.append('post[picture]', post.picture)
      fd.append('post[title]', post.title)
      fd.append('post[text]', post.text)
      @$http.post(uploadUrl, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @$location.path('/users')
      )
      .error( -> )

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    constructor: (@$scope, @$location, @$http, @$window, $rootScope) ->
      @bindCurrentUserToScope()

      $rootScope.$on('current_user:change', => @bindCurrentUserToScope())

      @$scope.sendPhoto = =>
        url = "/json/users/#{@$scope.current_user.username}/posts"
        post = 
          title: @$scope.title
          text: @$scope.text
          picture: @$scope.pictureFile
        @uploadFileToUrl(post, url)
