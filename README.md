# karma-touchbar-reporter

A Karma plugin. Displays test results on the TouchBar.

![Preview](preview.gif)

## Installation

Make sure you're on _macOS 10.13_, have _Xcode 9_ and _node_ installed. `karma-touchbar-reporter` uses a helper program to interface with the TouchBar. To compile the helper simply `cd` into the directory and run `npm i`.

```bash
cd karma-touchbar-reporter
npm i
```

## Options

The following options can be specified in your karma configuration under the key `"touchbarReporter"`. See `example/karma.conf.js` project for an example.

Option | Default                    | Effect
------ | -------------------------- | -------------------------------------------------
name   | `"name"` in `package.json` | Customize the name shown in the TouchBar popover.

## To Do List
 * Find proper icon for control strip item
 * Properly layout progress on larger test suites
 * Tap failed test to open failed expectation or reveal error message
