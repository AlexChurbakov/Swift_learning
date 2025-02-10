//
//  Action.js
//  Project 19
//
//  Created by apple on 10.12.2024.
//

var Action = function() {};

Action.prototype = {

run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},

finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}

};

var ExtensionPreprocessingJS = new Action
