# Client and Server Feature Flipping

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pinball_Flippers_-_Demolition_Man.JPG/1024px-Pinball_Flippers_-_Demolition_Man.JPG" width="100%">

[PinballWizard](https://www.youtube.com/watch?v=DthtDjhqVOU) brings feature flipping into a simple and uniform API.

[![The real pinball wizard](http://img.youtube.com/vi/DthtDjhqVOU/1.jpg)](https://www.youtube.com/watch?v=DthtDjhqVOU)
[Pinball Wizard ft. Sir Elton John](https://www.youtube.com/watch?v=DthtDjhqVOU)

## What is a *feature*?

A set of Ruby, HTML, JavaScript, and CSS that can be turned on or off.

A feature is simply a name and a state:

* *active*: If it is currently turned on and running.
* *inactive*: Not turned on.
* *disabled*: Not turned on and cannot be activated.


## Building
1. Define and register the feature in the [Ruby app](#ruby).
2. Build the [JavaScript component](#javascript).
3. Build the corresponding [HTML](#html) and [CSS](#css)
4. [Activate and test your feature](#activating-and-testing-features).

## Ruby

Define your feature in (typically `config/initializers/pinball_wizard.rb`).

```ruby
PinballWizard::DSL.build do
  # Active when the page loads:
  feature :example, active: true

  # Deactive when the page loads:
  feature :example, active: false
end
```

You can also pass in a proc for situtations where active/inactive is conditional. Returning false with make the feature inactive.

```ruby
PinballWizard::DSL.build do
  feature :example, active: proc { }
end
```

## HTML

Once the feature is registered, you can use Slim to include the HTML partial found at `app/views/features/example.slim`. This is only included if the feature is available, which allows the HTML to stay small.

```slim
= feature 'example'
```

To use a different partial for the same feature, pass in the `partial:` key. This will use `app/views/features/example_button.slim`.

If the feature is not active immediately, it's recommended to hide the HTML with inline or external CSS.

```slim
= feature 'example', partial: :example_button'
```

## CSS

PinballWizard doesn't have any CSS specific helpers, but recommends a convention similar to the Ruby version:

```scss
// public/scss/features/_example.scss

#example {}
```

Then include it on the main file with `@import 'features/example'`


## JavaScript

Features subscribe to events and respond when they're activated or deactivated. It no longer needs to know about Optimizely, cookies, or url params. (Single Responsibility Principle FTW)

One advantage to this approach is that you can activate features after the DOM is loaded (for testing).

When pinball runs, it will automatically activate the features.

### Example AMD/RequireJS Module

```coffee
define ['pinball_wizard'], (pinball) ->

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
define ['pinball_wizard'], (pinball) ->

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
define ['pinball_wizard'], (pinball) ->

    if pinball.isActive('example')
        # Do something
```

## Activating and Testing Features

### With a URL Param
Add `pinball` to the URL (e.g. `?pinball=example_a,example_b`).

### Post-Render (after page load)

```javascript
pinball.activate('example');
```

```javascript
pinball.deactivate('example');
```

Activating a feature that is already active or disabled will have no effect.

#### Optionally Supply a Source

Add an optional source as a second argument to help know where features are
activated while debugging.

```javascript
pinball.activate('example','source name');
```


## JsConfig
The application keeps a list of features and passes them in the JsConfig object (e.g. `window.ApartmentGuide`). These define what's available and activated on page load. AG is hooked up to PinballWizard to automatically be aware of these. No additional code is necessary.

`{ "feature_name": "state", "feature_name": "state" }`

e.g. `{ "feature_a": "active", "feature_b": "inactive", "feature_c": "disabled" }`

## Debugging

Add it to the url:
`?pinball=debug`

Turn on logging in JavaScript:
```js
pinball.debug();
```

Show current state in the JavaScript console:
```js
pinball.state();
```

## Integrations
* [Rails](https://github.com/primedia/pinball_wizard/wiki/Integrating-with-Rails)
* [Sinatra with Slim](https://github.com/primedia/pinball_wizard/wiki/Integrating-with-Sinatra)
* [Optimizely](https://github.com/primedia/pinball_wizard/wiki/Integrating-a-Feature-with-Optimizely)
* [ConFusion](https://github.com/primedia/pinball_wizard/wiki/Integrating-a-Feature-with-ConFusion)

## Extra: Customize the Ruby Class

By default, features are instances of `PinballWizard::Feature`. You can define your own class and register it according to a hash key. This is useful to disable features.

```ruby
# e.g. app/features/my_feature.rb
module PinballWizard
  class MyFeature < Feature
    def determine_state
      if my_condition?
        disable "My Feature: My Reason"
      end
    end
  end
end

# e.g. config/initializers/pinball_wizard.rb
PinballWizard.configure do |c|
  c.class_patterns = my_option: PinballWizard::MyFeature
end

# e.g. config/features.rb
PinballWizard::DSL.build do
  feature :example, :my_option
end
```

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

[MIT](https://github.com/primedia/pinball_wizard/blob/master/LICENSE)
