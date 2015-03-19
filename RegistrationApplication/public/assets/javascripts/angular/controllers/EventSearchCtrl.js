angular.
    module("demo7App").controller("EventSearchController", EventSearchController);

EventSearchController.$inject = ['EventService', 'localStorageService', '$scope'];

function EventSearchController(eventService, localStorage, $scope) {
    var vm = this;
    vm.user = localStorage.get('user');

    vm.search = function(searchString){
        toastr.info(searchString);
        eventService.search(searchString).then(function(data){
            vm.results = data.events;
        });
    };
}