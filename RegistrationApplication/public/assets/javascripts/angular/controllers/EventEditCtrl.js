angular.
    module("RegistrationApp").controller("EventEditController", EventEditController);

EventEditController.$inject = ['EventService', '$routeParams', 'localStorageService', '$location', 'uiGmapGoogleMapApi', '$scope'];

function EventEditController(eventService, $routeParams, localStorage, $location, uiGmapGoogleMapApi, $scope) {
    var vm = this;
    vm.user = localStorage.get('user');
    $scope.map = {center: {latitude: 51.219053, longitude: 4.404418}, zoom: 14};
    $scope.options = {scrollwheel: true};
    eventService.getEvent($routeParams.id).then(function (data) {
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.event = data.data;
        vm.event.latitude = parseFloat(vm.event.latitude);
        vm.event.longitude = parseFloat(vm.event.longitude);
        vm.event.tags = vm.event.tags || [{name: ""}, {name: ""}, {name: ""}];
        if (!vm.event.tags) {
            vm.event.tag = {name: ""};
        }
        $scope.map = {center: {latitude: vm.event.latitude, longitude: vm.event.longitude}, zoom: 10};
    });
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
        delete event.created_at;
        event.tags = event.tags || [event.tag];
        eventService.update(event).then(function (data) {
            toastr.info("Updated the event");
            $location.path('/events/' + data.data.event.id);
        });
    };
    uiGmapGoogleMapApi.then(function (maps) {
    });
}