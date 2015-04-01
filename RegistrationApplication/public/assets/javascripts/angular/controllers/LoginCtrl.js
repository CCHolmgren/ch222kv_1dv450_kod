angular.
    module("RegistrationApp").controller("LoginController", LoginController);

LoginController.$inject = ['$rootScope', '$http', '$location', 'localStorageService', '$window', '$routeParams'];

function LoginController($rootScope, $http, $location, localStorage, $window, $routeParams) {
    var vm = this;
    vm.user = {};
    vm.login = function () {
        $http.post('/login', {'username': vm.user.username, 'password': vm.user.password}).then(function (data) {
            console.log(data);
            localStorage.set('token', JSON.stringify(data.data.token));
            localStorage.set('username', data.data.user.username);
            localStorage.set('user', JSON.stringify(data.data.user));

            $rootScope.$broadcast('tokenchanged', {key: 'token', newvalue: data.data.token});
            $rootScope.$broadcast('signedin');

            toastr.success("Logged in!");

            if ($routeParams.next) {
                $location.path($routeParams.next);
            } else {
                $location.path('/');
            }
        }, function(result){
            console.log(result);
            toastr.error(result.data.message, 'Login error');
        });

    }
}