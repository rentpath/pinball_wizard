require ['pinball_wizard'], (pinball) ->

  beforeEach ->
    pinball.debug()
    pinball.reset()

  describe 'initialize', ->

    it 'is defined', ->
      expect(pinball).toBeDefined()

  describe '#reset', ->

    it 'removes all features', ->
      pinball.add
        a: {}
      pinball.reset()
      expect(pinball.state()).toEqual({})

  describe '#add', ->

    it 'is available by default', ->
      pinball.add
        a: {}
      expect(pinball.get('a').available).toEqual(true)

    it 'is not activateImmediately', ->
      pinball.add
        a: {}
      expect(pinball.get('a').activateImmediately).toEqual(false)

    it 'honors available and activateImmediately attributes', ->
      pinball.add
        a: { available: true,  activateImmediately: true }
      expect(pinball.get('a')).toEqual
        name: 'a'
        available: true
        active: true
        activateImmediately: true

    it 'activates if activateImmediately', ->
      pinball.add
        a: { activateImmediately: true }
      expect(pinball.isActive('a')).toEqual(true)

    it 'does not activate if activateImmediately is false', ->
      pinball.add
        a: { activateImmediately: false }
      expect(pinball.isActive('a')).toEqual(false)

    describe 'with a url param', ->

      originalPathname = null

      beforeEach ->
        originalPathname = window.location.pathname

      afterEach ->
        window.history.replaceState(null, null, originalPathname)

      it 'is not activate when mismatched', ->
        urlParam = '?pinball_foo'
        window.history.replaceState(null, null, window.location.pathname + urlParam)
        pinball.add
          a: {}
        expect(pinball.isActive('a')).toEqual(false)

      it 'is activate with a missing url param', ->
        urlParam = '?pinball_a'
        # Mock a different url
        window.history.replaceState(null, null, window.location.pathname + urlParam)
        pinball.add
          a: {}
        expect(pinball.isActive('a')).toEqual(true)

  describe '#state', ->
    it 'displays a list based on state', ->
      pinball.add
        a: { activateImmediately: true  }
        b: {}
        c: { available: false}

      expect(pinball.state()).toEqual({
        a: { name: 'a', available: true,  active: true,  activateImmediately: true  }
        b: { name: 'b', available: true,  active: false, activateImmediately: false }
        c: { name: 'c', available: false, active: false, activateImmediately: false }
      })

  describe '#activate', ->

    it 'makes an available feature active', ->
      pinball.add
        a: { available: true, activateImmediately: true }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        name: 'a'
        available: true
        active: true
        activateImmediately: true

    it 'does not make an unavailable feature active', ->
      pinball.add
        a: { available: false, activateImmediately: false }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        name: 'a'
        available: false
        active: false
        activateImmediately: false

  describe '#deactivate', ->

    it 'makes an active feature inactive', ->
      pinball.add
        a: { available: true, activateImmediately: true  }
      pinball.deactivate 'a'

      expect(pinball.get('a')).toEqual
        name: 'a'
        available: true
        active: false
        activateImmediately: true

  describe '#isActive', ->

    beforeEach ->
      pinball.add
        a: {}

    it 'is true after activating', ->
      pinball.activate 'a'
      expect(pinball.isActive('a')).toEqual(true)

    it 'is false if not activated', ->
      expect(pinball.isActive('a')).toEqual(false)

      expect(pinball.get('a')).toEqual
        name: 'a'
        available: true
        active: false
        activateImmediately: false

  describe '#subscribe', ->

    callback = null
    beforeEach ->
      callback = jasmine.createSpy('callback')

    describe 'when the activate callback should be called', ->
      it 'calls after activating', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls it once on multiple activations', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        pinball.activate 'a'
        pinball.activate 'a'
        expect(callback.calls.count()).toEqual(1)

      it 'calls it twice when toggling activations', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.activate 'a'
        expect(callback.calls.count()).toEqual(2)

      it 'calls when subscribing then adding an activateImmediately feature', ->
        pinball.subscribe 'a', callback
        pinball.add
          a: { activateImmediately: true }
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing then adding and then activating a feature', ->
        pinball.subscribe 'a', callback
        pinball.add
          a: {}
        pinball.activate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing to an already active feature', ->
        pinball.add
          a: { activateImmediately: true }
        pinball.subscribe 'a', callback
        expect(callback).toHaveBeenCalled()

    describe 'when the activate callback should not be called', ->
      it 'does not call when the feature is missing', ->
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is not available', ->
        pinball.add
          a: { available: false }
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).not.toHaveBeenCalled()

    describe 'when the deactivate callback should be called', ->
      it 'calls after deactivate', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls it once on multiple deactivations', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.deactivate 'a'
        expect(callback.calls.count()).toEqual(1)

      it 'calls it twice when toggling deactivations', ->
        pinball.add
          a: {}
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback.calls.count()).toEqual(2)

      it 'calls when subscribing, adding adding an activateImmediately then deactivating', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: { activateImmediately: true }
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing then adding and then deactivating a feature', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: {}
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

    describe 'when the deactivate callback should not be called', ->
       it 'does not call when subscribing then adding an activateImmediately feature', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: { activateImmediately: true }
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is missing', ->
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is not available', ->
        pinball.add
          a: { available: false }
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).not.toHaveBeenCalled()

  describe '#push', ->
    it 'calls the function with the first entry and the args for the rest', ->
      spyOn(pinball, 'activate')
      pinball.push ['activate','my-feature']
      expect(pinball.activate).toHaveBeenCalledWith('my-feature')

  # Jasmine 2.0 Works on window.onload and doesn't play well with requirejs
  jasmine.getEnv().execute()
