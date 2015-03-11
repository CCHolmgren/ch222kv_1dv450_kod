angular.
    module("demo7App").controller("EventListController", EventListController);

EventListController.$inject = ['EventService','$filter'];

function EventListController(eventService, $filter) {
    var vm = this;

    eventService.get().then(function(data){
        vm.eventsList = Object.keys(data.events).map(function(key){console.log(key);return data.events[key]});
        vm.eventsListCopy = vm.eventsList;
        //Get all tags, and unnest the array
        vm.tags = vm.eventsList.map(function(event){
            //Each event has tags
            return event.tags;
        }).reduce(function(a,b){
            //Unnest those into a flat array
            return a.concat(b);
        });
    });
    vm.test = function(tt){
        console.log(tt);
        vm.eventsList = $filter('filter')(vm.eventsListCopy, tt.name);
    };
    vm.all = function(){
        vm.eventsList = vm.eventsListCopy;
    };
    vm.clearCache = function(){
        eventService.clearcache();
        console.log("Cache cleared");
    };

}