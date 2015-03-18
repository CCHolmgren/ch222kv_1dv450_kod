angular.
    module("demo7App").controller("EventEditController", EventEditController);

EventEditController.$inject = ['EventService', '$routeParams','localStorageService', '$location'];

function EventEditController(eventService, $routeParams, localStorage, $location) {
    var vm = this;
    vm.user = localStorage.get('user');

    eventService.getEvent($routeParams.id).then(function(data){
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.event = data.data;
        console.log("event.tags", vm.event.tags);
        vm.event.tags = vm.event.tags || [{name:""},{name:""},{name:""}];
        if(!vm.event.tags){
            vm.event.tag = {name:""};
        }
    });
    vm.removeTag = function(tag){
        var result = confirm("Are you sure you want to remove " + tag.name + " from the event?");
        if(result){
            vm.event.tags.splice(vm.event.tags.indexOf(tag), 1);
        }
    };
    vm.addTag = function(tag){
        console.log(tag);
        tag = angular.copy(tag);
        tags = tag.name.split(' ').map(function(name){
            return {name:name};
        }).forEach(function(new_tag){
            if(new_tag.name.length >= 4) {
                vm.event.tags.push(new_tag);
            }
        });

    };
    vm.save = function(){
        var event = angular.copy(vm.event);
        delete event.created_at;
        event.tags = event.tags || [event.tag];
        eventService.update(event).then(function(data){
            toastr.info("Sent update request");
            console.log(data);
        });
    }
}