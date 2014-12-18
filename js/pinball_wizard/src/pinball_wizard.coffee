'use strict'

define ->

  features = {}
  subscribers = {}

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
    _log 'Notify subscriber that %s is active', name
    subscriber.onActivate()

  _notifySubscribersOnDeactivate = (name) ->
    subscribers[name] ?= []
    for subscriber in subscribers[name]
      subscriber.onDeactivate()

  # Support ?pinball=name1,name2,debug
  _urlValueMatches = (value) ->
    for v in _urlValues()
      return true if value == v
    false

  _urlValues = (search = window.location.search) ->
    pairs = search.substr(1).split('&')
    for pair in pairs
      [key, value] = pair.split('=')
      if key == 'pinball' and value?
        return value.split(',')
    []
  urlValues = _urlValues() # Memoize

  add = (list) ->
    for name, state of list
      features[name] = state
      _log "Added %s: %s.", name, state

      if isActive(name)
        activate(name, "automatic. added as '#{state}'")
      else if _urlValueMatches(name, urlValues)
        activate(name, 'URL')

  get = (name) ->
    features[name]

  update = (name, state) ->
    features[name] = state

  activate = (name, sourceName = null) ->
    state = get(name)
    source = if sourceName? then " (source: #{sourceName})" else ''
    switch state
      when undefined
        _log "Attempted to activate %s, but it was not found%s.", name, source
      when 'inactive'
        _log "Activate %s%s.", name, source
        update(name, 'active')
        _notifySubscribersOnActivate(name)
      when 'active'
        _log "Attempted to activate %s, but it is already active%s.", name, source
      else
        _log "Attempted to activate %s, but it is %s%s.", name, state, source

  deactivate = (name, source = null) ->
    state = get(name)
    source = if sourceName? then " (source: #{sourceName})" else ''
    switch state
      when undefined
        _log "Attempted to deactivate %s, but it was not found%s.", name, source
      when 'active'
        _log "Dectivate %s%s.", name, source
        update(name, 'inactive')
        _notifySubscribersOnDeactivate(name)
      else
        _log "Attempted to deactivate %s, but it is %s%s.", name, state, source

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
    add:          add
    get:          get
    activate:     activate
    deactivate:   deactivate
    isActive:     isActive
    subscribe:    subscribe
    push:         push
    state:        state
    reset:        reset
    debug:        debug
    _urlValues:  _urlValues

  # Initialize
  if window?.pinball
    debug() if _urlValueMatches('debug')
    while window.pinball.length
      exports.push window.pinball.shift()
    window.pinball = exports

  exports
