angular.module("RegistrationApp").factory("TagService", TagService);

TagService.$inject = ['ResourceService', 'localStorageService', 'LocalStorageConstants', '$q'];

function TagService(resourceService, localStorage, LS, $q){
    var Tag = resourceService("tags");
    return {
        get:function(){
            var deferred = $q.defer();
            Tag.getCollection().then(function(data){
                deferred.resolve(data);
            });
            return deferred.promise;
        }
    }
}
