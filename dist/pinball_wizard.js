(function() {
  'use strict';
  var slice = [].slice;

  define(function() {
    var _buildSubscriber, _log, _notifySubscriberOnActivate, _notifySubscribersOnActivate, _notifySubscribersOnDeactivate, _urlValueMatches, _urlValues, activate, add, addCSSClassName, addFlipper, cssClassName, deactivate, debug, exports, features, get, isActive, logPrefix, push, removeCSSClassName, reset, showLog, state, subscribe, subscribers, toggle, update, urlValues;
    features = {};
    subscribers = {};
    showLog = false;
    logPrefix = '[PinballWizard]';
    _log = function() {
      var args, message;
      message = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      if (showLog && window.console && window.console.log) {
        console.log.apply(console, [logPrefix + " " + message].concat(slice.call(args)));
      }
    };
    _notifySubscribersOnActivate = function(name) {
      var i, len, ref, results, subscriber;
      if (subscribers[name] == null) {
        subscribers[name] = [];
      }
      ref = subscribers[name];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        subscriber = ref[i];
        results.push(_notifySubscriberOnActivate(subscriber, name));
      }
      return results;
    };
    _notifySubscriberOnActivate = function(subscriber, name) {
      _log('Notify subscriber that %s is active', name);
      return subscriber.onActivate();
    };
    _notifySubscribersOnDeactivate = function(name) {
      var i, len, ref, results, subscriber;
      if (subscribers[name] == null) {
        subscribers[name] = [];
      }
      ref = subscribers[name];
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        subscriber = ref[i];
        results.push(subscriber.onDeactivate());
      }
      return results;
    };
    _urlValueMatches = function(value) {
      var i, len, ref, v;
      ref = _urlValues();
      for (i = 0, len = ref.length; i < len; i++) {
        v = ref[i];
        if (value === v) {
          return true;
        }
      }
      return false;
    };
    _urlValues = function(search) {
      var i, key, len, pair, pairs, ref, value;
      if (search == null) {
        search = window.location.search;
      }
      pairs = search.substr(1).split('&');
      for (i = 0, len = pairs.length; i < len; i++) {
        pair = pairs[i];
        ref = pair.split('='), key = ref[0], value = ref[1];
        if (key === 'pinball' && (value != null)) {
          return value.split(',');
        }
      }
      return [];
    };
    urlValues = _urlValues();
    cssClassName = function(name, prefix) {
      if (prefix == null) {
        prefix = 'use-';
      }
      return prefix + name.split('_').join('-');
    };
    addCSSClassName = function(name, ele) {
      var cN;
      if (ele == null) {
        ele = document.documentElement;
      }
      cN = cssClassName(name);
      if (ele.className.indexOf(cN) < 0) {
        return ele.className += ' ' + cN;
      }
    };
    removeCSSClassName = function(name, ele) {
      var cN;
      if (ele == null) {
        ele = document.documentElement;
      }
      cN = cssClassName(name);
      if (ele.className.indexOf(cN) >= 0) {
        return ele.className = ele.className.replace(cN, '');
      }
    };
    add = function(list) {
      var name, results, state;
      results = [];
      for (name in list) {
        state = list[name];
        features[name] = state;
        _log("Added %s: %s.", name, state);
        if (isActive(name)) {
          results.push(activate(name, "automatic. added as '" + state + "'"));
        } else if (_urlValueMatches(name, urlValues)) {
          results.push(activate(name, 'URL'));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    get = function(name) {
      return features[name];
    };
    update = function(name, state) {
      return features[name] = state;
    };
    activate = function(name, sourceName) {
      var source, state;
      if (sourceName == null) {
        sourceName = null;
      }
      state = get(name);
      source = sourceName != null ? " (source: " + sourceName + ")" : '';
      switch (state) {
        case void 0:
          return _log("Attempted to activate %s, but it was not found%s.", name, source);
        case 'inactive':
          _log("Activate %s%s.", name, source);
          update(name, 'active');
          addCSSClassName(name);
          return _notifySubscribersOnActivate(name);
        case 'active':
          return _log("Attempted to activate %s, but it is already active%s.", name, source);
        default:
          return _log("Attempted to activate %s, but it is %s%s.", name, state, source);
      }
    };
    deactivate = function(name, source) {
      var state;
      if (source == null) {
        source = null;
      }
      state = get(name);
      source = typeof sourceName !== "undefined" && sourceName !== null ? " (source: " + sourceName + ")" : '';
      switch (state) {
        case void 0:
          return _log("Attempted to deactivate %s, but it was not found%s.", name, source);
        case 'active':
          _log("Dectivate %s%s.", name, source);
          update(name, 'inactive');
          removeCSSClassName(name);
          return _notifySubscribersOnDeactivate(name);
        default:
          return _log("Attempted to deactivate %s, but it is %s%s.", name, state, source);
      }
    };
    toggle = function(name, element) {
      if (isActive(name)) {
        deactivate(name);
        element.innerHTML = "(+)";
      } else {
        activate(name);
        element.innerHTML = "(-)";
      }
      return false;
    };
    isActive = function(name) {
      return get(name) === 'active';
    };
    _buildSubscriber = function(onActivate, onDeactivate) {
      return {
        onActivate: onActivate != null ? onActivate : function() {},
        onDeactivate: onDeactivate != null ? onDeactivate : function() {}
      };
    };
    subscribe = function(name, onActivate, onDeactivate) {
      var subscriber;
      _log('Added subscriber to %s', name);
      subscriber = _buildSubscriber(onActivate, onDeactivate);
      if (subscribers[name] == null) {
        subscribers[name] = [];
      }
      subscribers[name].push(subscriber);
      if (isActive(name)) {
        return _notifySubscriberOnActivate(subscriber, name);
      }
    };
    push = function(params) {
      var method;
      method = params.shift();
      return this[method].apply(this, params);
    };
    state = function() {
      return features;
    };
    reset = function() {
      return features = {};
    };
    debug = function() {
      return showLog = true;
    };
    addFlipper = function() {
      var feature, flipperDiv, flipperHTML, i, len, linkText, ref, toggledText;
      flipperDiv = document.createElement("iframe");
      flipperDiv.setAttribute('id', 'flipper_frame');
      flipperHTML = "<h3>Available Features:</h3><ul>";
      ref = Object.keys(features);
      for (i = 0, len = ref.length; i < len; i++) {
        feature = ref[i];
        if (isActive(feature)) {
          linkText = "-";
        } else {
          linkText = "+";
        }
        if (isActive(feature)) {
          toggledText = "(+)";
        } else {
          toggledText = "(-)";
        }
        flipperHTML += "<li>" + feature + "&nbsp;<a href='javascript:void(0);' onclick=parent.pinball.toggle('" + feature + "',this);>(" + linkText + ")</a></li>";
      }
      flipperHTML += "</ul>";
      flipperHTML += "<br/>";
      flipperHTML += "<a href='javascript:void(0);' onclick=parent.$('#flipper_frame').hide();>close</a>";
      flipperDiv.srcdoc = flipperHTML;
      flipperDiv.style.cssText = "position:fixed;top:0;left:0;width:300px;height:250px;background:white;opacity:.9;font-size:12pt;z-index:99999;";
      return document.getElementsByTagName('body')[0].appendChild(flipperDiv);
    };
    exports = {
      add: add,
      get: get,
      activate: activate,
      deactivate: deactivate,
      toggle: toggle,
      isActive: isActive,
      subscribe: subscribe,
      push: push,
      state: state,
      reset: reset,
      debug: debug,
      cssClassName: cssClassName,
      addCSSClassName: addCSSClassName,
      removeCSSClassName: removeCSSClassName,
      _urlValues: _urlValues
    };
    if (typeof window !== "undefined" && window !== null ? window.pinball : void 0) {
      if (_urlValueMatches('debug')) {
        debug();
      }
      while (window.pinball.length) {
        exports.push(window.pinball.shift());
      }
      window.pinball = exports;
      if (_urlValueMatches('debug')) {
        addFlipper();
      }
    }
    return exports;
  });

}).call(this);
