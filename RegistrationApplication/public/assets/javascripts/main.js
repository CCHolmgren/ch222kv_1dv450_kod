angular
    .module('RegistrationApp', ['ngRoute', 'LocalStorageModule', 'uiGmapgoogle-maps'])
    .config(['$routeProvider', '$locationProvider',
        function ($routeProvider, $locationProvider) {
            $routeProvider.
                when('/', {
                    templateUrl: 'assets/templates/partials/index.html',
                    redirectTo: function (current, path, search) {
                        if (search.goto) {
                            // if we were passed in a search param, and it has a path
                            // to redirect to, then redirect to that path
                            return "/" + search.goto
                        }
                        else {
                            // else just redirect back to this location
                            // angular is smart enough to only do this once.
                            return "/"
                        }
                    }
                }).
                when('/login', {
                    templateUrl: 'assets/templates/partials/login.html',
                    controller: 'LoginController',
                    controllerAs: 'login'
                }).
                when('/logout', {
                    templateUrl: 'assets/templates/partials/logout.html',
                    controller: 'LogoutController',
                    controllerAs: 'logout'
                }).
                when('/events', {
                    templateUrl: 'assets/templates/partials/event-list.html',
                    controller: 'EventListController',
                    controllerAs: 'events'
                }).
                when('/events/new', {
                    templateUrl: 'assets/templates/partials/event-create.html',
                    controller: 'EventCreateController',
                    controllerAs: 'event'
                }).
                when('/events/search', {
                    templateUrl: 'assets/templates/partials/search.html',
                    controller: 'EventSearchController',
                    controllerAs: 'event'
                }).
                when('/events/:id', {
                    templateUrl: 'assets/templates/partials/event-detail.html',
                    controller: 'EventDetailController',
                    controllerAs: 'event'
                }).
                when('/events/:id/edit', {
                    templateUrl: 'assets/templates/partials/event-edit.html',
                    controller: 'EventEditController',
                    controllerAs: 'event'
                }).
                when('/tags/:id', {
                    templateUrl: 'assets/templates/partials/tag-event-list.html',
                    controller: 'TagEventListController',
                    controllerAs: 'tags'
                }).
                when('/tags', {
                    templateUrl: 'assets/templates/partials/tag-list.html',
                    controller: 'TagListController',
                    controllerAs: 'tags'
                }).
                otherwise({
                    redirectTo: '/'
                });

            $locationProvider.html5Mode(true);
        }])
    .config(function (localStorageServiceProvider) {
        localStorageServiceProvider
            .setPrefix('RegistrationApp')
            .setStorageType('sessionStorage')
            .setNotify(true, true)
    })
    .constant('API', {
        'url': "http://localhost:3000/api/v1/",
        'format': 'application/json'
    })
    .constant('LocalStorageConstants', {
        'tagsKey': 't',
        'eventsKey': 'e'
    }).factory('authInterceptor', function ($rootScope, $q, localStorageService, $location) {
        return {
            request: function (config) {
                config.headerse = config.headers || {};
                if (localStorageService.get('token')) {
                    config.headers.Authorization = 'Bearer ' + localStorageService.get('token').value;
                }
                return config;
            },
            response: function (response) {
                if (response.status == 401) {
                    toastr.warn("You must be signed in to do that. Please sign in before");
                    var path = $location.path();
                    $location.path('/login').search({next: path});
                }
                return response || $q.when(response);
            }
        }
    }).config(function ($httpProvider) {
        $httpProvider.interceptors.push('authInterceptor');
    }).directive('ngConfirmClick', [function () {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                element.bind('click', function () {
                    var message = attrs.ngConfirmMessage;
                    if (message && confirm(message)) {
                        scope.$apply(attrs.ngConfirmClick);
                    }
                });
            }
        }
    }]);