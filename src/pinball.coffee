'use strict'

define ->

  features = {}

  add = (list) ->
    for name, attributes of list
      features[name] = buildFeature(attributes.available, attributes.activatedByDefault)

  get = (name) ->
    features[name]

  buildFeature = (available, activatedByDefault) ->
    available:          available
    activated:          false
    activatedByDefault: activatedByDefault

  activate = (name) ->
    feature = get(name)
    if feature?.available
      feature.activated = true

  state = ->
    features

  reset = ->
    features = {}

  # Exports
  add:      add
  get:      get
  activate: activate
  state:    state
  reset:    reset
