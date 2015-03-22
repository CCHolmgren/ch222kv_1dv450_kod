angular.
    module("RegistrationApp").controller("EventSearchController", EventSearchController);

EventSearchController.$inject = ['EventService', 'localStorageService', '$scope'];

function EventSearchController(eventService, localStorage, $scope) {
    var vm = this;
    vm.user = localStorage.get('user');

    vm.search = function(searchString){
        toastr.info("Query: " + searchString);
        eventService.search(searchString).then(function(data){
            vm.results = data.events;
        },function(){
            console.log(arguments);
            toastr.error("The search could not finish, please try again, if you want.", "Error");
        });
    };
}