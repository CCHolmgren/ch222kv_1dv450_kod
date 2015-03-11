angular
    .module('demo7App', ['ngRoute', 'LocalStorageModule']) // you must inject the ngRoute (included as a separate js-file)
    .config(['$routeProvider', '$locationProvider',
        function($routeProvider, $locationProvider) {
            $routeProvider.
                when('/', {
                    templateUrl: 'assets/templates/partials/index.html',
                    redirectTo: function(current, path, search){
                        if(search.goto){
                            // if we were passed in a search param, and it has a path
                            // to redirect to, then redirect to that path
                            return "/" + search.goto
                        }
                        else{
                            // else just redirect back to this location
                            // angular is smart enough to only do this once.
                            return "/"
                        }
                    }
                }).
                when('/events', {
                    templateUrl: 'assets/templates/partials/event-list.html',
                    controller: 'EventListController',
                    controllerAs: 'events' // players could be seen as an instance of the controller, use it in the view!
                }).
                when('/player/:id', {
                    templateUrl: 'assets/templates/partials/player-detail.html',
                    controller: 'PlayerDetailController',
                    controllerAs: 'player'
                }).
                when('/tags', {
                    templateUrl: 'assets/templates/partials/tag-list.html',
                    controller: 'TagListController',
                    controllerAs: 'tags' // tags could be seen as an instance of the controller, use it in the view!
                }).
                otherwise({
                    redirectTo: '/'
                });

            $locationProvider.html5Mode(true); // This removes the hash-bang and use the Session history management >= IE10
        }])
    .config(function (localStorageServiceProvider) {
        // The module give me some stuff to configure
        localStorageServiceProvider
            .setPrefix('demo7app')
            .setStorageType('sessionStorage')
            .setNotify(true, true)
    })
    .constant('API', { // here I also can declare constants
        'key': "3256939b745006b070f30b945e26805a966e81398949a187ccfcb25f60ff7c0f", // bad practice!? Key on client....
        'url': "http://localhost:3000/api/v1/", // base url
        'format': 'application/json' // Default representation we want
    })
    .constant('LocalStorageConstants', {
        'playersKey' : 'p', // just some keys for sessionStorage-keys
        'tagsKey'   : 't',
        'eventsKey'  : 'e'
    });