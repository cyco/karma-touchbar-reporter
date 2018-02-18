var ChildProcess = require("child_process");
var Path = require("path");

var Commands = {
    onRunStart: "r",
    onRunComplete: "R",
    onBrowserStart: "b",
    onBrowserComplete: "B",
    onExit: "c",

    specSuccess: "s",
    specSkipped: "n",
    specFailure: "f"
};

var TouchbarReporter = function(baseReporterDecorator) {
    baseReporterDecorator(this);

    var helperPath = Path.resolve(
        __dirname,
        "./helper/DerivedData/helper/Build/Products/Debug/karma-touchbar-reporter"
    );
    var helper = ChildProcess.spawn(helperPath);

    function proxyCommand(cmd) {
        return function() {
            helper.stdin.write(cmd + "\n");
        };
    }
    this.onRunStart = proxyCommand(Commands.onRunStart);
    this.onRunComplete = proxyCommand(Commands.onRunComplete);
    this.onBrowserStart = proxyCommand(Commands.onBrowserStart);
    this.onBrowserComplete = proxyCommand(Commands.onBrowserComplete);
    this.specSuccess = proxyCommand(Commands.specSuccess);
    this.specSkipped = proxyCommand(Commands.specSkipped);
    this.specFailure = proxyCommand(Commands.specFailure);

    this.onExit = function(done) {
        proxyCommand(Commands.onExit)();

        helper.removeAllListeners("close");
        helper.on("close", done);
        helper.kill("SIGHUP");
    };
};

TouchbarReporter.$inject = ["baseReporterDecorator"];

module.exports = {
    "reporter:touchbar": ["type", TouchbarReporter]
};
