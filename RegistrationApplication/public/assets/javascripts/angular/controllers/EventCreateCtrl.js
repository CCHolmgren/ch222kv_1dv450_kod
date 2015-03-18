angular.
    module("demo7App").controller("EventCreateController", EventCreateController);

EventCreateController.$inject = ['EventService', '$routeParams','localStorageService', '$location'];

function EventCreateController(eventService, $routeParams, localStorage, $location) {
    var vm = this;
    vm.user = localStorage.get('user');
    vm.event = {name:"",description:"",short_description:"",latitude:"", longitude:"",tags:""};

    vm.save = function(){
        var event = angular.copy(vm.event);
        eventService.create(event).then(function(data){
            toastr.info("Sent create request");
            console.log(data);
        }, function(){
            console.log("Errors", arguments);
        });
    }
}