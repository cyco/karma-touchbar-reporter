module.exports = function(config) {
    config.set({
        basePath: "./",
        frameworks: ["jasmine"],
        files: ["index.js"],
        reporters: ["touchbar", "dots"],
        touchbarReporterConfig: {
            name: "Test Project"
        },
        plugins: [require("../"), "karma-jasmine"]
    });
};
