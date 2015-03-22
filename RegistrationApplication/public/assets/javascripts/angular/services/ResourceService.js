angular
    .module("RegistrationApp")
    .factory('ResourceService', ResourceService);

ResourceService.$inject = ['$http', 'API'];

function ResourceService($http, API) {
    return function (collectionName) {
        var Resource = function (data) {
            angular.extend(this, data);
        };

        Resource.updateItem = function (item) {
            var req = {
                method: 'PUT',
                url: API.url + collectionName + '/' + item.id,
                haeders: {
                    'Accept': API.format
                },
                data: item
            };
            return $http(req).then(function (response) {
                return response;
            });
        };

        Resource.getCollection = function () {
            var req = {
                method: 'GET',
                url: API.url + collectionName,
                headers: {
                    'Accept': API.format,
                    'X-APIKEY': API.key,
                    'Authorization': API.key
                },
                params: {
                    'limit': '100'
                }
            };
            return $http(req).then(function (response) {

                var result = {};

                angular.forEach(response.data, function (value, key) {

                    result[key] = new Resource(value);
                });
                return result;
            });
        };

        Resource.getSingle = function (resourceInfo) {

            var url;
            if (resourceInfo.hasOwnProperty('url')) {
                url = resourceInfo.url;
            }
            else if (resourceInfo.hasOwnProperty('instanceName') && resourceInfo.hasOwnProperty('id')) {
                url = API.url + resourceInfo.instanceName + "/" + resourceInfo.id
            }
            else {
                return false;
            }

            var req = {
                method: 'GET',
                url: url,
                headers: {
                    'Accept': API.format,
                    'X-APIKEY': API.key,
                    'Authorization': "fae3ca98ef2d44cf89d8f49a5fa027d2"
                }
            };
            return $http(req).success(function (response) {
                return response;
            });
        };

        Resource.save = function (data) {
            var req = {
                method: 'POST',
                url: API.url + collectionName,
                headers: {
                    'Accept': API.format,
                    'X-APIKEY': API.key
                },
                data: data
            };
            return $http(req).then(function (response) {
                return new Resource(response.data);
            });
        };
        Resource.removeItem = function (id) {
            var req = {
                method: 'DELETE',
                url: API.url + collectionName + "/" + id,
                headers: {
                    'Accept': API.format,
                    'X-APIKEY': API.key,
                    'Authorization': API.key
                }
            };
            return $http(req).then(function (response) {
                return new Resource(response.data);
            })
        };

        Resource.search = function (query) {
            var req = {
                method: 'GET',
                url: API.url + collectionName + '/search',
                headers: {
                    'Accept': API.format
                },
                params: {
                    'q': query
                }
            };
            return $http(req).then(function (response) {
                return new Resource(response.data);
            });
        };

        return Resource;
    }

};