angular.
    module("demo7App").controller("EventDetailController", EventDetailController);

EventDetailController.$inject = ['EventService', '$routeParams','localStorageService', '$location'];

function EventDetailController(eventService, $routeParams, localStorage, $location) {
    var vm = this;
    vm.user = localStorage.get('user');
    eventService.getEvent($routeParams.id).then(function(data){
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.event = data.data;
        console.log(data.data);
    });
    vm.remove = function(){
        eventService.remove($routeParams.id).then(function(data){
            console.log("Removed", data);
            eventService.clearEvents();
            $location.path('/');
        });
    }
}