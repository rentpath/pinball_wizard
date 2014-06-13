'use strict'

define ->

  features = {}
  subscribers = {}

  showLog = false

  _log = (message, args = {}, prefix = '[pinball.js]') ->
    console.log("#{prefix} #{message}", args) if showLog

  _notifySubscribersOnActivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      _notifySubscriberOnActivate(subscriber)

  _notifySubscriberOnActivate = (subscriber) ->
    subscriber.onActivate()

  _notifySubscribersOnDeactivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      subscriber.onDeactivate()

  add = (list) ->
    for name, feature of list
      features[name] = _buildFeature(feature.available, feature.activeByDefault)
      _log "Added feature #{name}. %O", feature

      if feature.activeByDefault
        activate(name)

  # TODO: Move to null object pattern
  get = (name) ->
    features[name]

  _buildFeature = (available, activeByDefault) ->
    available:       if available? then available else true
    active:          false
    activeByDefault: if activeByDefault? then activeByDefault else false

  # TODO: Move to null object pattern
  activate = (name) ->
    feature = get(name)
    if feature? == false
      _log "Attempted to activate #{name}, but it was not found."
    else if feature?.available
      if feature.active
        _log "Attempted to activate #{name}, but it is already active. %O", feature
      else
        _log "Activate feature #{name}. %O", feature
        feature.active = true
        _notifySubscribersOnActivate(name)
    else
      _log "Attempted to activate #{name}, but it is not available. %O", feature

  # TODO: Move to null object pattern
  deactivate = (name) ->
    feature = get(name)
    if feature? == false
      _log "Attempted to deactivate #{name}, but it was not found."
    else if feature?.active
      _log "Dectivate feature #{name}. %O", feature
      feature.active = false
      _notifySubscribersOnDeactivate(name)
    else
      _log "Attempted to deactivate #{name}, but it was already inactive. %O", feature

  isActive = (name) ->
    get(name)?.active

  _buildSubscriber = (onActivate, onDeactivate) ->
    onActivate:   if onActivate?   then onActivate else ->
    onDeactivate: if onDeactivate? then onDeactivate else ->

  subscribe = (name, onActivate, onDeactivate) ->
    subscriber = _buildSubscriber(onActivate, onDeactivate)
    subscribers[name] ?= []
    subscribers[name].push(subscriber)
    _notifySubscriberOnActivate(subscriber) if isActive(name)

  state = ->
    features

  reset = ->
    features = {}

  debug = ->
    showLog = true

  # Exports
  add:        add
  get:        get
  activate:   activate
  deactivate: deactivate
  isActive:   isActive
  subscribe:  subscribe
  state:      state
  reset:      reset
  debug:      debug
