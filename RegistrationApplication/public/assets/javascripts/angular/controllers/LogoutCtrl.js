angular.
    module("demo7App").controller("LogoutController", LogoutController);

LogoutController.$inject = ['$rootScope', '$location', 'localStorageService'];

function LogoutController($rootScope, $location, localStorage) {
    var vm = this;
    if(!localStorage.get('token')){
        $location.path('/');
    }
    vm.logout = function(){
        $rootScope.username = null;
        $rootScope.token = null;
        localStorage.remove('token');
        $rootScope.$broadcast('tokenchanged', {key:'token', newvalue:null});
        $rootScope.$broadcast('signedout');
        localStorage.clearAll();
        toastr.success("Logged out!");
        $location.path('/');
    }
}