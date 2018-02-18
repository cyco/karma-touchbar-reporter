function declareTest(name, duration, result) {
    it(name, done => {
        expect(result).toEqual("success");
        setTimeout(done, duration);
    });
}

function makeRandomTests(count, failureProbability, minDuration) {
    for (var i = 0; i < count; i++) {
        var duration = minDuration + 100 * Math.round(Math.random());
        declareTest(
            "Test " + i,
            duration,
            Math.random() < failureProbability ? "failure" : "success"
        );
    }
}

describe("karma-touchbar-reporter", () => {
    makeRandomTests(34, 0.1, 100);
});
