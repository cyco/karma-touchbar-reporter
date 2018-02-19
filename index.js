var ChildProcess = require("child_process");
var Path = require("path");
var FS = require("fs");
var Util = require("util");

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

var TouchbarReporter = function(baseReporterDecorator, config) {
    baseReporterDecorator(this);

    var touchbarReporterConfig = config.touchbarReporterConfig || {};
    var name =
        touchbarReporterConfig.name ||
        process.mainModule.paths
            .filter(p => p.indexOf("/node_modules/karma/") === -1)
            .map(p => p.slice(0, -"node_modules".length))
            .filter(p => FS.existsSync(Path.resolve(p, "package.json")))
            .map(p => {
                var name = p.split("/").slice(0, -1)[0];
                try {
                    var parentPackage = require(Path.resolve(
                        p,
                        "package.json"
                    ));
                    name = (parentPackage && parentPackage.name) || name;
                } catch (e) {}
                return name;
            })
            .find(p => p) ||
        "";

    var helperPath = Path.resolve(
        __dirname,
        "./build/Release/karma-touchbar-reporter"
    );
    var helper = ChildProcess.spawn(helperPath, [
        name,
        Util.format(
            "%s//%s:%s%s",
            config.protocol,
            config.hostname,
            config.port,
            config.urlRoot
        )
    ]);
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

TouchbarReporter.$inject = ["baseReporterDecorator", "config"];

module.exports = {
    "reporter:touchbar": ["type", TouchbarReporter]
};
