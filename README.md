# Feature Flipping FTW

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pinball_Flippers_-_Demolition_Man.JPG/1024px-Pinball_Flippers_-_Demolition_Man.JPG" width="100%">

pinball brings feature flipping into a simple and uniform API.

## What is a *feature*?

A set of Ruby, HTML, JavaScript, and CSS that can be turned on or off.

An feature has several attributes:

* *Active*: If it is currently turned on and running.
* *ActiveByDefault*: If it should activate without by itself.
* *Available*: If it can be activated. Defaults to `true`. Used primarily with other integrations.


## Building
1. Define and register the feature in the [Ruby app](#ruby) and set `active_by_default` to `false`.
2. Build the corresponding [HTML](#html) and [CSS](#css)
3. Build the [JavaScript component](#javascript).
4. Test by adding the name prefixed with `pinball_` to the URL param. e.g. `?pinball_example`.
5. *Optional:* Work with SO to setup the tests according to the name.

## Ruby

Define your feature in `app/features`.

```ruby
# app/features/example.rb

class ExampleFeature
  include Pinball::Feature
  available true
  active_by_default false
end

Pinball::Registry.add(ExampleFeature)

```

You can also pass in a block for situtations where availability is conditional.

```ruby
# app/features/example.rb

class ExampleFeature
  include Pinball::Feature

  available do
    # conditionally return true/false
  end

  active_by_default do
    # conditionally return true/false
  end
end

Pinball::Registry.add(ExampleFeature)

```

## HTML

Once the feature is registered, you can use slim to include the HTML partial found at `app/views/features/example.slim`. This is only included if the feature is available, which allows the HTML to stay small.

```slim
= feature 'example'
```

To use a different partial for the same feature, pass in the `partial:` key. This will use `app/views/features/example_button.slim`.

If the feature is not active by default, it's recommended to hide the HTML with inline or external CSS.

```slim
= feature 'example', partial: :example_button'
```

## CSS

Pinball doesn't have any CSS specific helpers, but recommends a convention similar to the Ruby version:

```scss
// public/scss/features/_example.scss

#example {}
```

Then include it on the main file with `@import 'features/example'`


## JavaScript

Features subscribe to events and respond when they're activated or deactivated. It no longer needs to know about Optimizely, cookies, or url params. (Single Responsibility Principle FTW)

One advantage to this approach is that you can activate features after the DOM is loaded (for testing).

When pinball runs, it will automatically activate the features.
Deactivating is optional and may not be supported.


### Example AMD/RequireJS Module

```coffee
define ['pinball'], (pinball) ->

  # Define feature component functions here ...

  pinball.subscribe 'example',
    ->
      # callback when activated. e.g. show it
    ->
      # callback when deactivated. e.g. hide it.

  # Return component functions to expose.
```

### Example Flight Component

```coffee
define ['pinball'], (pinball) ->

  @after 'initialize', ->
    pinball.subscribe 'example',
      =>
        # callback when activated. e.g. show it
      =>
        # callback when deactivated. e.g. hide it.

```

### Asking *(pseudo-code)*

As an alternative, a feature may check if it's active. This method is not preferred since it only occurs once during page load.

```coffee
define ['pinball'], (pinball) ->

    if pinball.isActive('example')
        # Do something
```

## Activating and Testing Features

### With a URL Param
Append `?pinball_example` to the URL.

### Post-Render (after page load)

```javascript
pinball.activate('example');
```

```javascript
pinball.deactivate('example');
```

Activating a feature that is already active will have no effect.

## JsConfig
The application keeps a list of features and passes them in the JsConfig object (e.g. `window.ApartmentGuide`). These define availability and what's active by default. AG is hooked up to Pinball to automatically be aware of these. No additional code is necessary.

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

## Tests

Both `rspec` and `jasmine` can be run with the `rspec` and `rake jasmine` commands.


## Contributing

This is a [README driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) process, please contribute by modifying this document. Code will come later.

To compile the CoffeeScript and run Jasmine, start foreman: `foreman start`.

## Next

- Handle reverse/opposite features. e.g. when optimizely activates a new search UI, it should deactivate the previous one.

## Future Versions

- Build a UI panel that shows the status of each feature. Allow
  toggling. Ship it as a bookmarklet or Chrome developer tools panel.

## Credits

  - Pinball photo:
    - [ElHeineken](http://commons.wikimedia.org/wiki/User:ElHeineken)
    - http://creativecommons.org/licenses/by/3.0/

## License

TBD
