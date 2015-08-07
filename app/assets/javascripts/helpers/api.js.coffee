app = angular.module('app')
app.service 'Api',
  class Api
    @$inject = ['$http', '$window', '$q']

    constructor: (@$http, @$window, @$q) ->

    loadCurrentUser: ->
      dfr = new @$q.defer()
      addr = "/json/users/"
      @$http.get(addr).success (response) => 
        @$window.current_user = response.user
        dfr.resolve(@$window.current_user?.username)
      dfr.promise  

    loadUser: ($scope, user_id) ->
      dfr = new @$q.defer()
      addr = "/json/users/#{user_id}"
      @$http.get(addr).success (response) =>
        $scope.user = response.user
        @$window.user = $scope.user
        $scope.friendship = response.meta.friendship
        dfr.resolve()
      dfr.promise  

    loadUserPosts: ($scope, user_id) ->
      dfr = new @$q.defer()
      addr = "/json/users/#{user_id}/posts"
      @$http.get(addr).success (response) =>
        $scope.posts = response.posts
        @$window.posts_ids = _.pluck($scope.posts, 'id')
        dfr.resolve()
      dfr.promise

    loadPost: ($scope, user_id, post_id) ->
      dfr = new @$q.defer()
      addr = "/json/users/#{user_id}/posts/#{post_id}"
      @$http.get(addr).success (response) =>
        $scope.post = response.post_with_comments
        $scope.comments = response.post_with_comments.comments
        $scope.my_like_id = response.meta.my_like_id
        $scope.likers = response.meta.likers
        $scope.prev_id = @findPrevId(post_id)
        $scope.next_id = @findNextId(post_id)
        dfr.resolve()
      dfr.promise

    loadFriendships: ($scope, user_id) ->
      dfr = new @$q.defer()
      addr = "/json/users/#{user_id}/friendships"
      @$http.get(addr).success (response) ->
        $scope.friends = response.friendships
        dfr.resolve()
      dfr.promise

    #private

    findNextId: (post_id) ->
      pos = @findPosInArray(post_id)
      if pos >= @$window.posts_ids.length - 1
        return null
      else
        return @$window.posts_ids[pos+1]

    findPrevId: (post_id) ->
      pos = @findPosInArray(post_id)
      if pos <= 0
        return null
      else
        return @$window.posts_ids[pos-1]

    findPosInArray: (post_id) ->
      _.indexOf(@$window.posts_ids, post_id)      

