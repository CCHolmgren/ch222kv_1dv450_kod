angular.
    module("demo7App").controller("EventEditController", EventEditController);

EventEditController.$inject = ['EventService', '$routeParams','localStorageService', '$location'];

function EventEditController(eventService, $routeParams, localStorage, $location) {
    var vm = this;
    vm.user = localStorage.get('user');

    eventService.getEvent($routeParams.id).then(function(data){
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.event = data.data;
    });

    vm.save = function(){
        var event = angular.copy(vm.event);
        delete event.created_at;
        eventService.update(event).then(function(data){
            toastr.info("Sent update request");
            console.log(data);
        });
    }
}