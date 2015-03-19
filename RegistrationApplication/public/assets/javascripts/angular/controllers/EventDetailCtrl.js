angular.
    module("demo7App").controller("EventDetailController", EventDetailController);

EventDetailController.$inject = ['EventService', '$routeParams','localStorageService', '$location', '$scope'];

function EventDetailController(eventService, $routeParams, localStorage, $location, $scope) {
    var vm = this;
    vm.user = localStorage.get('user');

    $scope.map = {center: {latitude: 51.219053, longitude: 4.404418 }, zoom: 14 };
    $scope.options = {scrollwheel: true};


    eventService.getEvent($routeParams.id).then(function(data){
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.event = data.data;
        $scope.map = {center: {latitude: vm.event.latitude, longitude: vm.event.longitude }, zoom: 10 };
        console.log(data.data);
    });
    vm.remove = function(){
        eventService.remove($routeParams.id).then(function(data){
            console.log("Removed", data);
            toastr.success("Successfully removed the event!");
            eventService.clearEvents();
            $location.path('/events');
        });
    };
    $scope.remove = vm.remove;
}