# Client and Server Feature Flipping

<img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pinball_Flippers_-_Demolition_Man.JPG/1024px-Pinball_Flippers_-_Demolition_Man.JPG" width="100%">

[<img src="http://img.youtube.com/vi/DthtDjhqVOU/1.jpg" height="40"> The Who & Elton John - Pinball Wizard (Tommy 1975)](https://www.youtube.com/watch?v=DthtDjhqVOU)

`PinballWizard` brings feature flipping into a simple and uniform API in both client-side JavaScript and Ruby.

## Why?

PinballWizard is intended to work with heavily cached pages (e.g. Varnish) that need feature flipping. It works well with third parties such as [Optimizely](http://optimizely.com/) where flipping occurs after HTML is rendered.

## What is a *feature*?

A set of Ruby, HTML, JavaScript, and CSS that can be turned on or off.

A feature is simply a name and default state:

* *active*: If it is currently turned on and running.
* *inactive*: Not turned on.
* *disabled*: Not turned on and cannot be activated.


## Building
1. Define and register the feature in the [Ruby app](#ruby).
2. Build the [JavaScript component](#javascript).
3. Write the corresponding [HTML](#html) and [CSS](#css)
4. [Activate and test your feature](#activating-and-testing-features).

## Ruby

Define your feature (typically in `config/initializers/pinball_wizard.rb`).

```ruby
PinballWizard::DSL.build do
  # Active when the page loads:
  feature :example, active: true

  # Deactive when the page loads:
  feature :example, active: false
end
```

You can also pass in a proc for situtations where active/inactive is conditional. Returning false will make the feature inactive.

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

PinballWizard automatically adds and removes a CSS class named `.use-{feature-name}` to the `<html>` tag. This allows you to write CSS when features are active.

It is also recommended to organize your CSS similar to Ruby:

```scss
// app/assets/stylesheets/features/_example.scss

.use-example {
  // CSS when the 'example' feature is active.
}
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
      ->
        # callback when activated. e.g. show it
      ->
        # callback when deactivated. e.g. hide it.

```

### Asking *(pseudo-code)*

As an alternative, a feature may check if it's active. This method is not preferred since it only occurs once during page load.

```coffee
define ['pinball_wizard'], (pinball) ->

    if pinball.isActive('example')
        # Do something
```

## Activating Features for Testing (once)

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
## Activating Features (permanently)

To turn on and keep a feature on, you can activate it permanently in the console. This is only for your browser's session.

```javascript
pinball.activatePermanently('example')
```

You can permanently activate multiple features like so:

```javascript
pinball.activatePermanently('example1', 'example2')
```

#### See a List of Permanent Features

```javascript
pinball.permanent()
```

#### Reset Permanent Features

```javascript
pinball.resetPermanent()
```

## JsConfig Registry
The application keeps a list of features and passes them in the JsConfig object (e.g. `window.pinball`). These define what's available and activated on page load.

#### Plain JavaScript
```javascript
<head>
  <script type="text/javascript">
	window.pinball = window.pinball || []
    window.pinball.push(['add', { "feature_a": "active", "feature_b": "inactive", "feature_c": "disabled" }]);
  </script>
<head>
```

#### Ruby (example is in slim)
```slim
head
  javascript:
    window.pinball = window.pinball || [];
    window.pinball.push(['add', #{{PinballWizard::Registry.to_h.to_json}}]);
```

## Removing the Flicker

When using `.use-{feature-name}`, you may notice a shift or flicker in the UI. This occurs when pinball's JavaScript executes after the `DOMContentReady` event. To prevent this, add `dist/css_tagger.min.js` into your `<head>` tag. For example:

```html
<head>
	<script type="text/javascript">
		// paste snippet from dist/css_tagger.min.js
	</script>
</head>
```

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

For RentPath specific functionality, including ConFusion, see [pinball_wizard-rentpath](https://github.com/primedia/pinball_wizard-rentpath)

## Extra: Custom Ruby Class

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

## Getting started for development.
```
git checkout dev
git pull origin dev
git checkout -b my_branch
npm run preversion
```

## A basic red-green-refactor workflow.

```
npm install
npm run watch
npm run watch:test # in another terminal window or pane
```

## Examples of common tasks.

npm script commands are defined in the scripts section of package.json.
To see a full list of available npm commands, run:

```
npm run
```

### Install NPM Dependencies

```
npm install
```

### One-time compile of application source and tests.

```
npm run compile
```

### Compile application source & tests and build the distribution as files change.

```
npm run watch
```

### Running Tests.

One time.

```
npm test
```

Watch continuously and run tests when code or specs change.

```
npm run watch:test
```

### Cleaning

Remove compiled code and tests in .tmp/.

```
npm run clean
```

Remove compiled code and tests, `node_modules`

```
npm run clean:all
```

Remove compiled code, tests, `node_modules`; reinstall
node modules; recompile code and tests.

```
npm run reset
```

### Building a Distribution

To build a distribution and tag it, run one of the following commands.

```
npm version patch -m "Bumped to %s"
npm version minor -m "Bumped to %s"
npm version major -m "Bumped to %s"
```

There's a 'preversion' script in package.json that does the following:
  - Remove the .tmp/ directory.
  - Remove the node_modules directories.
  - Install all npm packages.
  - Compile the application source and specs.
  - Run the tests.
  - Rebuild the distribution.

Just build a distribution.

```
npm run build
```

## Notes
  - The `dist/` directory must be part of the repo - don't gitignore it!


## Contributing

Fork and submit a pull request. This is a [README driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) process, please contribute by modifying this document.


## Credits

  - Pinball photo:
    - [ElHeineken](http://commons.wikimedia.org/wiki/User:ElHeineken)
    - http://creativecommons.org/licenses/by/3.0/

## License

[MIT](https://github.com/primedia/pinball_wizard/blob/master/LICENSE)
