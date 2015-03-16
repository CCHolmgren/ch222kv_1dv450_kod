angular.
    module("demo7App").controller("LoginController", LoginController);

LoginController.$inject = ['$rootScope', '$http','$location', 'localStorageService','$window'];

function LoginController($rootScope, $http, $location, localStorage, $window) {
    var vm = this;
    vm.user = {};
    console.log("window", $window);
    vm.login = function(){
        $http.post('/login', {'username': vm.user.username, 'password':vm.user.password}).success(function(data){
            localStorage.set('token', JSON.stringify(data.token));
            $rootScope.$broadcast('tokenchanged', {key:'token', newvalue:data.token});
            console.log(data);
            localStorage.set('username', data.user.username);
            localStorage.set('user', JSON.stringify(data.user));
            $location.path('/');
        });

    }
}