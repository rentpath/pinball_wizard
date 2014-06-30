'use strict'

define ->

  features = {}
  subscribers = {}

  urlPrefix = 'pinball_'
  showLog = false

  _log = (message, args = {}, prefix = '[pinball.js]') ->
    if showLog && window.console && window.console.log
      console.log("#{prefix} #{message}", args)
    return

  _notifySubscribersOnActivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      _notifySubscriberOnActivate(subscriber, name)

  _notifySubscriberOnActivate = (subscriber, name) ->
    _log 'Notify subscriber that %O is activate', name
    subscriber.onActivate()

  _notifySubscribersOnDeactivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      subscriber.onDeactivate()

  _urlMatches = (name) ->
    window.location.search.indexOf("#{urlPrefix}#{name}") != -1

  _shouldActivate = (feature) ->
    feature.active or _urlMatches(feature.name)

  add = (list) ->
    for name, feature of list
      feature = _buildFeature(name, feature.active, feature.available)
      features[name] = feature
      _log "Added feature #{name}. %O", feature

      if _shouldActivate(feature)
        activate(feature.name)

  # TODO: Move to null object pattern
  get = (name) ->
    features[name]

  _buildFeature = (name, active, available) ->
    name:                name
    active:              if active?    then active    else false
    available:           if available? then available else true

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

  # NOTE: This method is a long term goal and may be removed. Do not rely on it.
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

  # If the feature is already active, the callback will immediately be invoked.
  subscribe = (name, onActivate, onDeactivate) ->
    _log 'Added subscriber to %O', name
    subscriber = _buildSubscriber(onActivate, onDeactivate)
    subscribers[name] ?= []
    subscribers[name].push(subscriber)
    _notifySubscriberOnActivate(subscriber, name) if isActive(name)

  push = (params) ->
    method = params.shift()
    @[method].apply(@, params)

  state = ->
    features

  reset = ->
    features = {}

  debug = ->
    showLog = true

  # Exports
  exports =
    add:        add
    get:        get
    activate:   activate
    deactivate: deactivate
    isActive:   isActive
    subscribe:  subscribe
    push:       push
    state:      state
    reset:      reset
    debug:      debug

  if window?.pinball
    while window.pinball.length
      exports.push window.pinball.shift()
    window.pinball = exports

  exports
