controllers = angular.module('controllers')

controllers.controller 'SignUpController',
  class SignUpController
    @$inject = ['$scope', '$routeParams', '$location', '$http']

    requestNewUser: (user, uploadUrl) ->
      fd = new FormData()
      fd.append('user[username]', user.username)
      fd.append('user[email]', user.email)
      fd.append('user[password]', user.password)
      fd.append('user[password_confirmation]', user.password_confirmation)
      @$http.post(uploadUrl, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .success( =>
        @$location.path('/')
      )
      .error( -> )

    constructor: ($scope, $routeParams, @$location, @$http) ->
      
      $scope.submit = =>
        url = "/authentication"
        @requestNewUser($scope.user, url)


controllers.controller 'SignInController',
  class SignInController
    @$inject = ['$scope', '$routeParams', '$location', '$http']

    requestLoginUser: (user, uploadUrl) ->
      fd = new FormData()
      fd.append('user[login]', user.login)
      fd.append('user[password]', user.password)
      fd.append('user[remember_me]', user.remember_me)
      @$http.post(uploadUrl, fd,
          transformRequest: angular.identity,
          headers: 'Content-Type': undefined
      )
      .then ( (response) =>
        @$location.path('/')
      ), (response) =>
        @$scope.error = response.data?.error


    constructor: (@$scope, $routeParams, @$location, @$http) ->
      
      @$scope.submit = =>
        url = "/authentication/sign_in.json"
        @requestLoginUser(@$scope.user, url)
