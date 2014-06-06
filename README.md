# Flippers FTW

**Issue: Multiple parties need to see features at different times**

* Devs working on the feature (local, CI and QA)
* QA reviews
* ConFusion
* Optimizely Experiment Testing

## Terms

### Theme
* Overall "skin" with an associated CSS file.
* Has a default list of enabled features.

### Feature
* An individual item. i.e. the RRW.
  * *Available*: If a feature can be turned on.
  * *Enabled*: If a feature is turned on and running.
* ConFusion controls availability and is essentially a "kill switch".
* Optimizely can enable only available features.
* Feature's component should only know if it's enabled or disabled. It should
  not know about Optimizely or how to disable it's opposite.

## The API: Method Queue

```js
_pinball.push(['methodname','arguments', function () { /* callback */ }])
_pinball.push(['enableFeature','name-of-feature'])
```

## JsConfig
* Array of hashes with each feature and its name and if it's available.
* ConFusion flips the availability (currently named "enable").

## Optimizely
* String of mixed enabled features and theme (space separated). (window.activeExperiments?)
* Calls enable / disable for each feature.

# Execution Flow

- Initialize app's JsConfig
- Initialize pinball global
- Register themes
- Register features
- Activate Optimizely.
    - Request features to enable / disable.
- Determine the Theme.
- Include the Theme's CSS.
- Include App's JavaScript.
    - Feature registry configured. Show opposites and scoped to themes.
    - Features do not check if they're enabled.
- Determine enabled features (theme default + optimizely - force disabled)
- Trigger an event for each known feature.

```js
<script src="//cdn.optimizely.com/js/...js" type="text/javascript"></script>

// window.ApartmentGuide in initialzied with JsConfig

_pinball = _pinball || [];
_pinball.push(['registerThemes', ApartmentGuide.themes]);
_pinball.push(['registerFeatures', ApartmentGuide.features]);

// Activate Optimizely
// It may enable / disable features like:
//   _pinball.push(['enableFeature', 'name']);
// No feature events triggered.
window.optimizely.push(["activate"]);

// TBD: Use Something from Optimizely to determine name.
// Q: Does the full pinball lib need to be ready here?
_pinball.push(['loadTheme', somethingFromOptimizely]);

// Load the apps' js with require (example from AG)
requirejs.config({ /*...*/ });
require(['es5-shim', 'es5-sham', 'main'], function (shim, sham, Main) {
  Main.init();
  _pinball.push(['activate']); // triggers events for each feature.
});
```

## Registering a Feature
```coffee
_pinball.push [
  'registerFeature'
    name: 'RRW'
    available: true
  ]
```

## Registering a Theme
```coffee
_pinball.push [
  'registerTheme',
    name: 'faceoff'
    stylesheet: 'all-faceoff'
    adSenseChannel: '123'
  ]
```

## Enabling and Disabling a Feature

Triggers `onFeatureEnabled', 'name'` if pinball is activated.

## Listening for Events

Features listen for events to determine when they're enabled or disabled. They should know how to enable and disable themselves.

```coffee
define ['pinball'], (pinball) ->

  # Define component functions here ...

  pinball.push [
    'listen',
    'name-of-this-feature',
    ->
      # callback when this feature is enabled. show it
    , ->
      # callback when this feature is disabled. hide it.
  ]

  # Return component functions to expose.
```

On component initialization, should the feature know if it's enabled or disabled? Current line of thought is *no*. It should wait for it the enabling event. to be fired..


## Method Queue Implementation

[Source](http://calendar.perfplanet.com/2012/the-non-blocking-script-loader-pattern/)

```js
var self = this;
_pinball = _pinball || [];
while(_pinball.length) {
  var params = _pinball.shift(); // remove the first item from the queue
  var method = params.shift();   // remove the method from the first item

  self[method].apply(self, params);
}

_pinball.push = function(params) {
  var method = params.shift(); // remove the method from the first item
  self[method].apply(self, params);
}
```
