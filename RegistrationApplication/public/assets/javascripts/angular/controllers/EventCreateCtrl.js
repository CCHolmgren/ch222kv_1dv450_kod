angular.
    module("RegistrationApp").controller("EventCreateController", EventCreateController);

EventCreateController.$inject = ['EventService', '$routeParams', 'localStorageService', '$location'];

function EventCreateController(eventService, $routeParams, localStorage, $location) {
    var vm = this;
    vm.user = localStorage.get('user');
    vm.event = {name: "", description: "", short_description: "", latitude: "", longitude: "", tags: ""};

    vm.save = function () {
        var event = angular.copy(vm.event);
        eventService.create(event).then(function (data) {
            toastr.info("Created the event");
            $location.path('events/' + data.data.event.id);
        }, function () {
            toastr.error("Something went wrong with the creation of the event. Please try again.", 'Error');
        });
    }
}