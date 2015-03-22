angular.
    module("RegistrationApp").controller("MenuController", MenuController);

MenuController.$inject = ['$rootScope', 'localStorageService'];

function MenuController($rootScope, localStorage) {
    var vm = this;
    vm.token = localStorage.get('token');
    vm.username = localStorage.get('username');
    vm.user = localStorage.get('user');

    $rootScope.$on('tokenchanged', function(event, parameters){
        vm.token = parameters.newvalue;
    });
    $rootScope.$on('signedout', function(){
        vm.username = null;
        vm.user = null;
    });
    $rootScope.$on('signedin', function(){
        vm.username = localStorage.get('username');
        vm.user = localStorage.get('user');
    });
}