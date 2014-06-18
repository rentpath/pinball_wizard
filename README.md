# Feature Flipping FTW

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pinball_Flippers_-_Demolition_Man.JPG/1024px-Pinball_Flippers_-_Demolition_Man.JPG" width="100%">

pinball.js brings feature flipping into a simple and uniform API.

## What is a "feature"?

A set of HTML, JavaScript and CSS that can be flippable.

An individual component (e.g. the RRW) that has several attributes:

* *Active*: If it is currently turned on and running.
* *ActiveByDefault*: Self-explanatory.
* *Available*: If it can be activated. Defaults to `true`. Used with other integrations.


## Build Process
1. Determine a name. e.g. `xyz`.
3. Add it to the [JsConfig](#jsconfig) and set `activeByDefault` to `false`.
4. [Build the JavaScript component](#javascript).
5. Build the corresponding [HTML](#html) and [CSS](#css)
4. Test by adding the name prefixed with `pinball_` to the URL param. e.g. `?pinball_xyz`.
5. *Optional:* Work with SO to setup the tests according to the name.

## JavaScript

Features subscribe to events and respond when they're activated or deactivated. This can also be used to prevent initializing the component when never activated.

It should only know if it's active or inactive. It should not know about Optimizely, cookies, or url params. (Single Responsibility Principle FTW)

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

As an alternative, a feature may check if it's active. This method is not preferred.

```coffee
define ['pinball'], (pinball) ->

    if pinball.isActive('feature-name')
        # Do something
```

## HTML

```slim
- feature :xyz
  div#foo
```

## CSS
Separate SCSS file under `app/public/scss/features/_xyz.scss`.

## Activating and Testing Features

### With a URL Param
Append `?pinball_xyz` to the URL.

### Post-Render (after page load)

```javascript
pinball.activate('feature-name');
```

```javascript
pinball.deactivate('feature-name');
```

Activating a feature that is already active will have no effect.

## JsConfig
The application has a list of features and passes them in the JsConfig object (e.g. `window.ApartmentGuide`). These define availability and what's active by default.

* Array of hashes for each feature
    * Keys: `available`, `active`, and `activeByDefault`

## Debugging

Turn on logging:
```js
pinball.debug();
```

Show current state:
```js
pinball.state();
```

## Integrations
* [Optimizely](https://github.com/primedia/pinball.js/wiki/Integrating-a-Feature-with-Optimizely)
* [ConFusion](https://github.com/primedia/pinball.js/wiki/Integrating-a-Feature-with-ConFusion)

## Contributing

This is a [README driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) process, please contribute by modifying this document. Code will come later.

## Next

- Handle disabling the reverse feature. e.g. when optimizely activates a new search UI, it should deactivate the previous one.
- Define the ruby equivalent of features to aid the Confusion -> JsConfig flow.

## Future Versions

- Build a UI panel that shows the status of each feature. Allow
  toggling. Ship it as a bookmarklet or Chrome developer tools panel.

## Credits

  - Pinball photo:
    - [ElHeineken](http://commons.wikimedia.org/wiki/User:ElHeineken)
    - http://creativecommons.org/licenses/by/3.0/

## License

TBD
