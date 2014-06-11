# Feature Flipping FTW

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pinball_Flippers_-_Demolition_Man.JPG/1024px-Pinball_Flippers_-_Demolition_Man.JPG" width="100%">

pinball.js brings feature flipping into a simple and uniform API. It simplifies integration with Optimizely, ConFusion, JavaScript, and CSS. It also addresses the needs for multiple stake holders to flip features at different times during our process:

* Devs working on the feature (local, CI and QA)
* QA reviews
* ConFusion
* Optimizely Experiment Testing

This is a README driven development process. No code has been written.

## What is a "feature"?
* An individual component (e.g. the RRW) that has several attributes:
  * *Active*: If it is currently turned on and running.
  * *ActiveByDefault*: Self-explanatory.
  * *Available*: If it can be activated. Was called `enable`. Typically controlled by ConFusion.

### ConFusion and Optimizely Integration
* ConFusion controls availability and is essentially a "kill switch".
* Optimizely can activate only available features.

## Manually Activating and Testing Features

pinball automatically hooks up a url param named `?optly_FEATURE_NAME`.
Just append it and pinball will fire the correct activated events.

When you need to test a specific feature, there are two ways to activate it:

### Features that span multiple URLs
After Optimizely is setup, you can activate it through their API by appending to the URL: `?optimizely_x[EXPERIMENT_ID]=[VARIATION_ID]`

### Post-Render (after page load)

```javascript
pinball.activate('feature-name');
```

```javascript
pinball.deactivate('feature-name');
```

## Build Process
1. Work with SO to determine the name. e.g. `xyz`.
2. Add it to ConFusion through a migration.
3. Add it to the JsConfig and deactivate it by default. (Investigate a single ruby file and do it automatically).
4. Test by adding the name prefixed with `optly_` to the URL param. e.g. `?optly_xyz`.
5. Work with SO to setup the tests according to the name.

## Hooking Up Your Feature's Component

Features subscribe to events and respond when they're activated or deactivated. This can also be used to prevent initializing the component when never activated.

It should only know if it's activated or deactivated. It should not know about Optimizely, cookies, or url params. (Single Responsibility Principle FTW)
  
One advantage to this approach is that you can activate features after the DOM is loaded.

When pinball.js runs, it will call wither activate or deactivate for every feature. Deactivate can be called without ever calling activate.

### RequireJS Module *(pseudo-code)*

```coffee
define ['pinball'], (pinball) ->

  # Define feature component functions here ...

  pinball.subscribe 'feature-name',
    ->
      # callback when activated. e.g. show it
    ->
      # callback when deactivated. e.g. hide it.

  # Return component functions to expose.
```

### Flight Component *(pseudo-code)*

*TODO*: Test the event ordering with this implementation.

```coffee
define ['pinball'], (pinball) ->

  @after 'initialize', ->
    pinball.subscribe 'feature-name',
      ->
        # callback when activated. e.g. show it
      ->
        # callback when deactivated. e.g. hide it.

```

### Asking *(pseudo-code)*

As an alternative, a feature may check if it's activated. This method is not preferred.

```coffee
define ['pinball'], (pinball) ->

    if pinball.isActivated('feature-name')
        # Do something
```

## JsConfig
The application has a list of features and passes them in the JsConfig object (e.g. `window.ApartmentGuide`). These define availability and what's activated by default.

* Array of hashes for each feature
    * Keys: `available`, `activated`, and `activatedByDefault`

# Example Execution Flow

```js
<script src="//cdn.optimizely.com/js/...js" type="text/javascript"></script>

// Initialize app's JsConfig
// window.ApartmentGuide is initialzied with JsConfig. Example:
ApartmentGuide = {
  features: [
    rrw: { available: true, activatedByDefault: false }
  ]
};

// Activate Optimizely
window.optimizely.push(['activate']);

// Load the app's js with require
requirejs.config({ /*...*/ });
require(['es5-shim', 'es5-sham', 'main', 'optimizely-config', 'pinball'], function (shim, sham, Main, optimizelyConfig, pinball) {
  Main.init();

 // Register features and defaults
 // Was previously ApartmentGuide.siteOptimization
 pinball.register(ApartmentGuide.features);

  // Activate from Optimizely space separated lists
  for experiment in window.rentPathExperiments
    pinball.activateFromList(experiment);

  // -- or --
  pinball.activateFromList(optimizelyConfig.activeExperiments);

  // Determine which features to activate: defaults + optimizely + manual url
  // Trigger callbacks for each feature (See "Hooking Up Your Feature's Component")
  pinball.publish();
});
```

## Debugging

Turn on logging:
```js
pinball.debug();
```

Show current state:
```js
pinball.state();
```

## Contributing

This is a [README driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) process, please contribute by modifying this document. Code will come later.

## Next

- Handle disabling the reverse feature. e.g. when optimizely activates a new search UI, it should deactivate the previous one.
- Define the ruby equivalent of features to aid the Confusion -> JsConfig flow.

## Future Versions

- Build a UI panel that shows the status of each feature. Allow
  toggling. Ship it as a bookmarklet or Chrome developer tools panel.
