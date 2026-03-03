var app = angular.module('HistogramApp', ['ngMaterial', 'ngMessages']);

// Define Cooper Union Theme
app.config(function ($mdThemingProvider) {
    var cooperMaroon = $mdThemingProvider.extendPalette('red', {
        '500': '#990000', // Cooper Union primary brand color
        'contrastDefaultColor': 'light'
    });

    $mdThemingProvider.definePalette('cooperMaroon', cooperMaroon);

    $mdThemingProvider.theme('default')
        .primaryPalette('cooperMaroon')
        .accentPalette('amber');
});

// File Upload Directive
app.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);

app.controller('MainController', function ($scope, $http, $mdToast, $interval) {
    $scope.isLoggedIn = false;
    $scope.loginData = {};
    $scope.username = "";

    $scope.availableFiles = [];
    $scope.equalizedFiles = [];
    $scope.connectedNodes = [];
    $scope.processingImages = {};
    $scope.upload = {}; // Wrap in object to avoid ng-if child scope shadowing
    $scope.uploading = false;

    // Simple mock login
    $scope.login = function () {
        if ($scope.loginData.username && $scope.loginData.password) {
            $scope.isLoggedIn = true;
            $scope.username = $scope.loginData.username;
            $scope.refreshFiles();
            $scope.refreshNodes();
        }
    };

    $scope.logout = function () {
        $scope.isLoggedIn = false;
        $scope.username = "";
        $scope.loginData = {};
    };

    $scope.showToast = function (message) {
        $mdToast.show(
            $mdToast.simple()
                .textContent(message)
                .position('bottom right')
                .hideDelay(3000)
        );
    };

    $scope.refreshNodes = function () {
        $http.get('/nodes').then(function (response) {
            $scope.connectedNodes = response.data.connected_workers;
        }, function (error) {
            console.error("Error fetching nodes", error);
        });
    };

    $scope.refreshFiles = function () {
        $http.get('/files').then(function (response) {
            $scope.availableFiles = response.data.files;
        });
        $http.get('/files/equalized').then(function (response) {
            $scope.equalizedFiles = response.data.files;
        });
    };

    $scope.uploadFile = function () {
        var file = $scope.upload.myFile;
        if (!file) {
            $scope.showToast("Please select a file first.");
            return;
        }

        var fd = new FormData();
        fd.append('file', file);

        $scope.uploading = true;
        $http.post('/upload', fd, {
            transformRequest: angular.identity,
            headers: { 'Content-Type': undefined }
        })
            .then(function (response) {
                $scope.uploading = false;
                $scope.showToast("File uploaded successfully.");
                $scope.refreshFiles();
            }, function (error) {
                $scope.uploading = false;
                $scope.showToast("Error uploading file: " + (error.data.detail || error.statusText));
            });
    };

    $scope.processImage = function (filename) {
        if ($scope.connectedNodes.length === 0) {
            $scope.showToast("Warning: No worker nodes connected. Master will process this locally.");
        }

        $scope.processingImages[filename] = true;
        $scope.showToast("Dispatched Job to Cluster: " + filename);

        $http.post('/process/' + filename).then(function (response) {
            // Processing happens in the background. We poll for the result.
            var poll = $interval(function () {
                $http.get('/files/equalized').then(function (res) {
                    var found = res.data.files.find(f => f.name.includes(filename.split('.')[0] + "_equalized"));
                    if (found) {
                        $scope.showToast("Processing complete: " + filename);
                        $scope.processingImages[filename] = false;
                        $scope.refreshFiles();
                        $interval.cancel(poll);
                    }
                });
            }, 5000); // poll every 5 seconds
        }, function (error) {
            $scope.processingImages[filename] = false;
            $scope.showToast("Error starting process.");
        });
    };
});
