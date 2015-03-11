angular.module("demo7App").factory("TagService", TagService);

TagService.$inject = ['ResourceService', 'localStorageService', 'LocalStorageConstants', '$q'];

function TagService(resourceService, localStorage, LS, $q){
    console.log("This");
    var Tag = resourceService("tags");
    return {
        get:function(){
            var items = localStorage.get(LS.tagsKey);

            var deferred = $q.defer();
            if(!items){
                Tag.getCollection().then(function(data){
                    localStorage.set(LS.tagKey, data);
                    deferred.resolve(data);
                });
            } else {
                console.log("Getting all the tags from the cache");

                deferred.resolve(items);
            }
            return deferred.promise;
        }
    }
}
