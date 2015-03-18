angular.
    module("demo7App").controller("EventListController", EventListController);

EventListController.$inject = ['$scope','EventService','uiGmapGoogleMapApi'];

function EventListController($scope, eventService, uiGmapGoogleMapApi) {
    var vm = this;
    $scope.map = {center: {latitude: 51.219053, longitude: 4.404418 }, zoom: 14 };
    $scope.options = {scrollwheel: true};
    eventService.get().then(function(data){
        vm.eventsList = Object.keys(data.events).map(function(key){console.log(key);return data.events[key]});
        vm.eventsListCopy = vm.eventsList;
        //Get all tags, and unnest the array
        console.log("eventsList", vm.eventsList);
        vm.tags = vm.eventsList.map(function(event){
            //Each event has tags
            return event.tags;
        }).reduce(function(a,b){
            //Unnest those into a flat array
            return a.concat(b.reduce(function(x,y){
                return x.concat(y.name);
            }, []));
        },[]).reduce(function(p,c){
            if(p.indexOf(c) < 0) p.push(c);
            return p;
        }, []);
        vm.eventsList.forEach(function(event){
            event.tags = event.tags.splice(event.tags.length-5, 5);
        });
        vm.users =  vm.eventsList.map(function(event){
            event.user = event.user || {username: null};
            return event.user.username;
        }).reduce(function(p,c){
            if(p.indexOf(c) < 0 && c != null) p.push(c);
            return p;
        }, []);
        console.log(vm.eventsList);
        vm.filteredByTag = [];
        vm.filteredByUser = null;
        var i = 0;
        vm.markers = vm.eventsList.map(function(element){
            return {latitude: element.latitude, longitude: element.longitude, idKey: i++};
        });
        console.log("markers:", vm.markers);
        console.log("vm", vm);
    });
    vm.filterEvents = function(tt){
        if(vm.filteredByTag.indexOf(tt) < 0){
            vm.filteredByTag.push(tt);
        }
        vm.eventsList = vm.eventsList.filter(function(a){
            return a.tags.filter(function(c){
                return c.name == tt;
            }).length > 0;
        });
        var i = 0;
        vm.markers = vm.eventsList.map(function(element){
            return {latitude: element.latitude, longitude: element.longitude, idKey: i++};
        });
    };
    vm.filterEventsByUser = function(u){
        vm.removeFilterByUser();
        vm.filteredByUser = u;
        vm.filteredByTag.forEach(function(element){
            vm.filterEvents(element);
        });
        vm.eventsList = vm.eventsList.filter(function(a){
            return a.user.username == u;
        });
        var i = 0;
        vm.markers = vm.eventsList.map(function(element){
            return {latitude: element.latitude, longitude: element.longitude, idKey: i++};
        });
    };
    vm.removeFilterByTag = function(f){
        vm.eventsList = vm.eventsListCopy;
        vm.filteredByTag.splice(vm.filteredByTag.indexOf(f), 1);
        vm.filteredByTag.forEach(function(element){
            vm.filterEvents(element);
        });
    };
    vm.removeFilterByUser = function(){
        vm.eventsList = vm.eventsListCopy;
        vm.filteredByUser = null;
        var i = 0;
        vm.markers = vm.eventsList.map(function(element){
            return {latitude: element.latitude, longitude: element.longitude, idKey: i++};
        });
    };
    vm.all = function(){
        vm.filteredByUser = null;
        vm.filteredByTag = [];
        vm.eventsList = vm.eventsListCopy;
        var i = 0;
        vm.markers = vm.eventsList.map(function(element){
            return {latitude: element.latitude, longitude: element.longitude, idKey: i++};
        });
    };
    vm.clearCache = function(){
        eventService.clearEvents();
        console.log("Events cleared");
    };
    uiGmapGoogleMapApi.then(function(maps){
    });
}