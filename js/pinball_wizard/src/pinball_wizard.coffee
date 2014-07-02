'use strict'

define ->

  features = {}
  subscribers = {}

  urlPrefix = 'pinball_'
  showLog = false
  logPrefix = '[PinballWizard]'

  _log = (message, args...) ->
    if showLog && window.console && window.console.log
      console.log("#{logPrefix} #{message}", args...)
    return

  _notifySubscribersOnActivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      _notifySubscriberOnActivate(subscriber, name)

  _notifySubscriberOnActivate = (subscriber, name) ->
    _log 'Notify subscriber that %s is activate', name
    subscriber.onActivate()

  _notifySubscribersOnDeactivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      subscriber.onDeactivate()

  _urlMatches = (name) ->
    window.location.search.indexOf("#{urlPrefix}#{name}") != -1

  _shouldActivate = (name) ->
    isActive(name) or _urlMatches(name)

  add = (list) ->
    for name, state of list
      features[name] = state
      _log "Added %s: %s.", name, state

      if _shouldActivate(name)
        activate(name)

  get = (name) ->
    features[name]

  update = (name, state) ->
    features[name] = state

  activate = (name) ->
    state = get(name)
    switch state
      when undefined
        _log "Attempted to activate %s, but it was not found.", name
      when 'inactive'
        _log "Activate %s.", name
        update(name, 'active')
        _notifySubscribersOnActivate(name)
      when 'active'
        _log "Attempted to activate %s, but it is already active.", name
      else
        _log "Attempted to activate %s, but it is %s", name, state

  deactivate = (name) ->
    state = get(name)
    switch state
      when undefined
        _log "Attempted to deactivate %s, but it was not found.", name
      when 'active'
        _log "Dectivate %s.", name
        update(name, 'inactive')
        _notifySubscribersOnDeactivate(name)
      else
        _log "Attempted to deactivate %s, but it is %s.", name, state

  isActive = (name) ->
    get(name) == 'active'

  _buildSubscriber = (onActivate, onDeactivate) ->
    onActivate:   if onActivate?   then onActivate else ->
    onDeactivate: if onDeactivate? then onDeactivate else ->

  # If the feature is already active, the callback is invoked immediately.
  subscribe = (name, onActivate, onDeactivate) ->
    _log 'Added subscriber to %s', name
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
