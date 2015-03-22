angular.
    module("RegistrationApp").controller("LoginController", LoginController);

LoginController.$inject = ['$rootScope', '$http','$location', 'localStorageService','$window', '$routeParams'];

function LoginController($rootScope, $http, $location, localStorage, $window, $routeParams) {
    var vm = this;
    vm.user = {};
    vm.login = function(){
        $http.post('/login', {'username': vm.user.username, 'password':vm.user.password}).success(function(data){
            localStorage.set('token', JSON.stringify(data.token));
            $rootScope.$broadcast('tokenchanged', {key:'token', newvalue:data.token});
            $rootScope.$broadcast('signedin');

            localStorage.set('username', data.user.username);
            localStorage.set('user', JSON.stringify(data.user));

            toastr.success("Logged in!");

            if($routeParams.next){
                $location.path($routeParams.next);
            } else {
                $location.path('/');
            }
        });

    }
}