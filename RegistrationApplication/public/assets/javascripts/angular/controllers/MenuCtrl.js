angular.
    module("demo7App").controller("MenuController", MenuController);

MenuController.$inject = ['$rootScope', 'localStorageService'];

function MenuController($rootScope, localStorage) {
    var vm = this;
    vm.token = localStorage.get('token');
    $rootScope.$on('tokenchanged', function(event, parameters){
        console.log(event, parameters);
        vm.token = parameters.newvalue;
    });
}