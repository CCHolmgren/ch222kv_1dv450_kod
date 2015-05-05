angular.
    module("RegistrationApp").controller("EventCreateController", EventCreateController);

EventCreateController.$inject = ['EventService', '$routeParams', 'localStorageService', '$location', '$scope', 'uiGmapGoogleMapApi'];

function EventCreateController(eventService, $routeParams, localStorage, $location, $scope, uiGmapGoogleMapApi) {
    var vm = this;
    vm.user = localStorage.get('user');
    $scope.map = {center: {latitude: 51.219053, longitude: 4.404418}, zoom: 14};
    $scope.options = {scrollwheel: true};
    vm.event = {name: "", description: "", short_description: "", latitude: 51.219053, longitude: 4.404418, tags: []};

    vm.removeTag = function (tag) {
        var result = confirm("Are you sure you want to remove " + tag.name + " from the event?");
        if (result) {
            vm.event.tags.splice(vm.event.tags.indexOf(tag), 1);
        }
    };
    vm.addTag = function (tag) {
        tag = angular.copy(tag);
        tags = tag.name.split(' ').map(function (name) {
            return {name: name};
        }).forEach(function (new_tag) {
            if (new_tag.name.length >= 4) {
                vm.event.tags.push(new_tag);
            }
        });
    };
    vm.save = function () {
        var event = angular.copy(vm.event);
        eventService.create(event).then(function (data) {
            toastr.info("Created the event");
            $location.path('events/' + data.event.id);
        }, function () {
            toastr.error("Something went wrong with the creation of the event. Please try again.", 'Error');
        });
    }
}