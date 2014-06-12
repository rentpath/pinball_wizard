require ['pinball'], (pinball) ->

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

    it 'is not activeByDefault', ->
      pinball.add
        a: {}
      expect(pinball.get('a').activeByDefault).toEqual(false)

    it 'honors available and activeByDefault attributes', ->
      pinball.add
        a: { available: true,  activeByDefault: true }
      expect(pinball.get('a')).toEqual
        available: true
        active: true
        activeByDefault: true

    it 'activates if activeByDefault', ->
      pinball.add
        a: { activeByDefault: true }
      expect(pinball.isActive('a')).toEqual(true)

    it 'does not activate if activeByDefault is false', ->
      pinball.add
        a: { activeByDefault: false }
      expect(pinball.isActive('a')).toEqual(false)

  describe '#state', ->
    it 'displays a list based on state', ->
      pinball.add
        a: { activeByDefault: true  }
        b: {}
        c: { available: false}

      expect(pinball.state()).toEqual({
        a: { available: true,  active: true,  activeByDefault: true  }
        b: { available: true,  active: false, activeByDefault: false }
        c: { available: false, active: false, activeByDefault: false }
      })

  describe '#activate', ->

    it 'makes an available feature active', ->
      pinball.add
        a: { available: true, activeByDefault: true }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        available: true
        active: true
        activeByDefault: true

    it 'does not make an unavailable feature active', ->
      pinball.add
        a: { available: false, activeByDefault: false }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        available: false
        active: false
        activeByDefault: false

  describe '#deactivate', ->

    it 'makes an active feature inactive', ->
      pinball.add
        a: { available: true, activeByDefault: true  }
      pinball.deactivate 'a'

      expect(pinball.get('a')).toEqual
        available: true
        active: false
        activeByDefault: true

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
        available: true
        active: false
        activeByDefault: false

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

      it 'calls when subscribing then adding an activeByDefault feature', ->
        pinball.subscribe 'a', callback
        pinball.add
          a: { activeByDefault: true }
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing then adding and then activating a feature', ->
        pinball.subscribe 'a', callback
        pinball.add
          a: {}
        pinball.activate 'a'
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

      it 'calls when subscribing, adding adding an activeByDefault then deactivating', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: { activeByDefault: true }
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
       it 'does not call when subscribing then adding an activeByDefault feature', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: { activeByDefault: true }
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

  # Jasmine 2.0 Works on window.onload and doesn't play well with requirejs
  jasmine.getEnv().execute()
