(function() {
    window.onload = function() {
        callNative("alert", "oi gente");
    }

    function callNative(method, parameters) {
        location.href = "native://" + method + "/#" + parameters;
    };


})();
