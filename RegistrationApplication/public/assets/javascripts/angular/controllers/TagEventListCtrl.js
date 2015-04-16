angular.
    module("RegistrationApp").controller("TagEventListController", TagEventListController);

TagEventListController.$inject = ['TagService', '$routeParams'];

function TagEventListController(tagService, $routeParams) {
    var vm = this;

    tagService.getEventsByTag($routeParams.id).then(function (data) {
        console.log(data);
        data.events = JSON.parse(data.events);
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.eventsList = Object.keys(data.events).map(function (key) {
            return data.events[key];
        });
    });
}