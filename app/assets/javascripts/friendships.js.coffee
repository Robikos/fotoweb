# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

controllers = angular.module('controllers')

controllers.controller 'FriendshipsController',
  class FriendshipsController
    @$inject = ['$scope', '$routeParams', 'Api']

    constructor: ($scope, $routeParams, Api) ->
      Api.loadFriendships($scope, $routeParams.user_id)
