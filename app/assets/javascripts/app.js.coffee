app = angular.module('app',[
  'templates',
  'ngRoute',
  'controllers',
  ])

app.config(['$httpProvider', 
  ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

    interceptor = ['$location', '$rootScope', '$q', 
      ($location, $rootScope, $q) ->
        success = (response) ->
          response

        error = (response) ->
          if response.status == 401
            $rootScope.$broadcast 'event:unauthorized'
            $location.path '/auth/login'
            return response
          $q.reject(response)

        (promise) ->
          promise.then(success, error)
    ]

    $httpProvider.interceptors.push(interceptor)
])

app.config([ '$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider)->
    $locationProvider.html5Mode(
      enabled: true
      requireBase: false
    )

    $routeProvider
      .when('/',
        templateUrl: "home/index.html"
        controller: 'HomeController'
      )
      .when('/auth/sign_in',
        templateUrl: "auth/login.html"
        controller: 'SignInController'
      )
      .when('/auth/sign_up'
        templateUrl: "auth/register.html"
        controller: 'SignUpController'
      )
      .when('/users',
        templateUrl: "posts/index.html"
        controller: 'CurrentUserController'
      )
      .when('/users/add_avatar',
        templateUrl: "users/add_avatar.html"
        controller: 'UsersAddAvatarController'
      )
      .when('/users/:user_id/posts',
        templateUrl: "posts/index.html"
        controller: 'UsersController'
      )
      .when('/users/:user_id/posts/new',
        templateUrl: "posts/new.html",
        controller: 'NewPostController'
      )
      .when('/users/:user_id/friendships',
        templateUrl: "friendships/index.html"
        controller: 'FriendshipsController'
      )
      
      # .when('/users/:user_id/posts/:id',
      #   templateUrl: "posts/show.html"
      #   controller: 'PostsController'
      # )
])
