angular.module("RegistrationApp").factory("EventService", EventService);

EventService.$inject = ['ResourceService', 'localStorageService', 'LocalStorageConstants', '$q'];

function EventService(resourceService, localStorage, LS, $q) {
    var Event = resourceService("events");
    return {
        get: function () {
            var deferred = $q.defer();
            Event.getCollection().then(function (data) {
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        getEvent: function (id) {
            var deferred = $q.defer();
            Event.getSingle({instanceName: "events", id: id}).then(function (data) {
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        clearEvents: function () {
            localStorage.remove(LS.eventsKey);
        },
        clearcache: function () {
            localStorage.clearAll();
        },
        remove: function (id) {
            var deferred = $q.defer();
            Event.removeItem(id).then(function (data) {
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        update: function (event) {
            var deferred = $q.defer();
            Event.updateItem(event).then(function (data) {
                deferred.resolve(data);
            });
            return deferred.promise;
        },
        create: function (event) {
            var deferred = $q.defer();
            Event.save(event).then(function (data) {
                deferred.resolve(data);
            }, function () {
                deferred.reject(arguments);
            });
            return deferred.promise;
        },
        search: function (query) {
            var deferred = $q.defer();
            Event.search(query).then(function (data) {
                deferred.resolve(data);
            }, function () {
                deferred.reject(arguments);
            });
            return deferred.promise;
        }
    }
}
