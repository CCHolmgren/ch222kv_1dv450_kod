angular.
    module("demo7App").controller("TagListController", TagListController);

TagListController.$inject = ['TagService'];

function TagListController(tagService) {
    var vm = this;

    tagService.get().then(function(data){
        //Convert the object data.tags to an array, since it is needed by angular to do filtering
        vm.tagsList = Object.keys(data.tags).map(function(key){console.log(key);return data.tags[key]});
    });
}