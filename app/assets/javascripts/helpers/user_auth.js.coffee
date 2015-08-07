app = angular.module('app')
app.service 'UserAuth',
  class UserAuth
    @$inject = ['$http', '$window' ,'Api', '$rootScope']

    constructor: (@$http, @$window, @Api, @$rootScope) ->

    reloadCurrentUser: ->
      @Api.loadCurrentUser().then(=>
        @$rootScope.$broadcast('current_user:change')
      )

    getCurrentUser: ->
      @reloadCurrentUser() unless @$window.current_user
      @$window.current_user

