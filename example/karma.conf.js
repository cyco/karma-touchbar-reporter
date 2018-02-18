module.exports = function(config) {
    config.set({
        basePath: "./",
        frameworks: ["jasmine"],
        files: ["index.js"],
        reporters: ["touchbar","dots"],
        plugins: [require("../"), 'karma-jasmine']
    });
};
