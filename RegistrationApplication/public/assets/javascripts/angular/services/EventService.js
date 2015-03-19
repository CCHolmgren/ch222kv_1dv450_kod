angular.module("demo7App").factory("EventService", EventService);

EventService.$inject = ['ResourceService', 'localStorageService', 'LocalStorageConstants', '$q'];
console.log("This");
function EventService(resourceService, localStorage, LS, $q){
    console.log("This");
    var Event = resourceService("events");
    return {
        get:function(){
            console.log("LS",LS);
            var items = localStorage.get(LS.eventsKey);

            var deferred = $q.defer();
            if(!items){
                Event.getCollection().then(function(data){
                    localStorage.set(LS.eventsKey, data);
                    console.log("data", data);
                    deferred.resolve(data);
                });
            } else {
                console.log("Getting all the events from the cache");

                deferred.resolve(items);
            }
            return deferred.promise;
        },
        getEvent:function(id){
            var deferred = $q.defer();
            Event.getSingle({instanceName: "events", id: id}).then(function(data){
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        clearEvents: function(){
            console.log("Removing", localStorage.get(LS.eventsKey));
            localStorage.remove(LS.eventsKey);
        },
        clearcache: function(){
            localStorage.clearAll();
        },
        remove:function(id){
            var deferred = $q.defer();
            Event.removeItem(id).then(function(data){
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        update:function(event){
            var deferred = $q.defer();
            Event.updateItem(event).then(function(data){
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        create:function(event){
            var deferred = $q.defer();
            Event.save(event).then(function(data){
                deferred.resolve(data);
            }, function(){
                deferred.reject(arguments);
            });
            return deferred.promise;
        },
        search:function(query){
            var deferred = $q.defer();
            Event.search(query).then(function(data){
                deferred.resolve(data);
            }, function(){
                deferred.reject(arguments);
            });
            return deferred.promise;
        }
    }
}
