controllers = angular.module('controllers')

controllers.controller 'UsersAddAvatarController',
  class UsersAddAvatarController
    @$inject = ['$scope', '$location', '$http', '$window', '$rootScope', 'UserAuth']

    bindCurrentUserToScope: ->
      @$scope.current_user = @$window.current_user

    uploadAvatarToUrl: (avatar, uploadUrl) ->
      fd = new FormData()
      fd.append('user[avatar]', avatar)
      @$http.put(uploadUrl, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @$location.path('/users')
      )
      .error( -> )

    constructor: (@$scope, @$location, @$http, @$window, $rootScope, UserAuth) ->
      UserAuth.getCurrentUser()
      @bindCurrentUserToScope()

      $rootScope.$on('current_user:change', => @bindCurrentUserToScope())

      @$scope.sendAvatar = =>
        url = "/json/users/#{@$scope.current_user.username}"
        avatar = @$scope.avatarFile
        @uploadAvatarToUrl(avatar, url)
