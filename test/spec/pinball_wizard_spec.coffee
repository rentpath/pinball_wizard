define ['pinball_wizard'], (pinball) ->

  beforeEach ->
    pinball.reset()

  describe 'initialize', ->
    it 'is defined', ->
      expect(pinball).toBeDefined()

  describe '#reset', ->
    it 'removes all features', ->
      pinball.add
        a: 'active'
      pinball.reset()
      expect(pinball.state()).toEqual({})

  describe '#add', ->
    it 'activates if active', ->
      pinball.add
        a: 'active'
      expect(pinball.isActive('a')).toEqual(true)

    it 'does not activate if inactive', ->
      pinball.add
        a: 'inactive'
      expect(pinball.isActive('a')).toEqual(false)

    it 'does not activate if disabled', ->
      pinball.add
        a: 'disabled: reason'
      expect(pinball.isActive('a')).toEqual(false)

    describe 'with a ?pinball=feature,feature url param', ->

      originalPathname = null

      beforeEach ->
        originalPathname = window.location.pathname

      afterEach ->
        window.history.replaceState(null, null, originalPathname)

      it 'is not active when mismatched', ->
        urlParam = '?pinball=foo,bar'
        window.history.replaceState(null, null, window.location.pathname + urlParam)
        pinball.add
          a: 'inactive'
          b: 'inactive'
        expect(pinball.isActive('a')).toEqual(false)
        expect(pinball.isActive('b')).toEqual(false)

      it 'is active when matching', ->
        urlParam = '?pinball=a,b'
        # Mock a different url
        window.history.replaceState(null, null, window.location.pathname + urlParam)
        pinball.add
          a: 'inactive'
          b: 'inactive'
        expect(pinball.isActive('a')).toEqual(true)
        expect(pinball.isActive('b')).toEqual(true)

  describe '#state', ->
    it 'displays a list based on state', ->
      pinball.add
        a: 'active'
        b: 'inactive'
        c: 'disabled: reason'

      expect(pinball.state()).toEqual({
        a: 'active'
        b: 'inactive'
        c: 'disabled: reason'
      })

  describe '#activate', ->
    it 'makes an inactive feature active', ->
      pinball.add
        a: 'inactive'
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual('active')

    it 'does not make a disabled feature active', ->
      pinball.add
        a: 'disabled'
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual('disabled')

  describe '#deactivate', ->
    it 'makes an active feature inactive', ->
      pinball.add
        a: 'active'
      pinball.deactivate 'a'

      expect(pinball.get('a')).toEqual('inactive')

  describe '#isActive', ->
    beforeEach ->
      pinball.add
        a: 'inactive'

    it 'is true after activating', ->
      pinball.activate 'a'
      expect(pinball.isActive('a')).toEqual(true)

  describe '#subscribe', ->
    callback = null
    beforeEach ->
      callback = jasmine.createSpy('callback')

    describe 'when the activate callback should be called', ->
      it 'calls after activating', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls it once on multiple activations', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        pinball.activate 'a'
        pinball.activate 'a'
        expect(callback.calls.count()).toEqual(1)

      it 'calls it twice when toggling activations', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.activate 'a'
        expect(callback.calls.count()).toEqual(2)

      it 'calls when subscribing then adding and then activating a feature', ->
        pinball.subscribe 'a', callback
        pinball.add
          a: 'inactive'
        pinball.activate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing to an already active feature', ->
        pinball.add
          a: 'active'
        pinball.subscribe 'a', callback
        expect(callback).toHaveBeenCalled()

    describe 'when the activate callback should not be called', ->
      it 'does not call when the feature is missing', ->
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is disabled', ->
        pinball.add
          a: 'disabled: reason'
        pinball.subscribe 'a', callback
        pinball.activate 'a'
        expect(callback).not.toHaveBeenCalled()

    describe 'when the deactivate callback should be called', ->
      it 'calls after deactivate', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls it once on multiple deactivations', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.deactivate 'a'
        expect(callback.calls.count()).toEqual(1)

      it 'calls it twice when toggling deactivations', ->
        pinball.add
          a: 'inactive'
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback.calls.count()).toEqual(2)

      it 'calls when subscribing, adding adding an active then deactivating', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: 'active'
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

      it 'calls when subscribing then adding and then deactivating a feature', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: 'inactive'
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).toHaveBeenCalled()

    describe 'when the deactivate callback should not be called', ->
       it 'does not call when subscribing then adding an active feature', ->
        pinball.subscribe 'a', null, callback
        pinball.add
          a: 'active'
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is missing', ->
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).not.toHaveBeenCalled()

      it 'does not call when the feature is disabled', ->
        pinball.add
          a: 'disabled'
        pinball.subscribe 'a', null, callback
        pinball.activate 'a'
        pinball.deactivate 'a'
        expect(callback).not.toHaveBeenCalled()

  describe '#push', ->
    it 'calls the function with the first entry and the args for the rest', ->
      spyOn(pinball, 'activate')
      pinball.push ['activate','my-feature']
      expect(pinball.activate).toHaveBeenCalledWith('my-feature')

  describe '#cssClassName', ->
    it 'builds the name with the prefix', ->
      expect(pinball.cssClassName('my_feature')).toEqual 'use-my-feature'

  describe '#addCSSClassName', ->
    it 'appends', ->
      ele = document.createElement 'div'
      pinball.addCSSClassName('my_feature', ele)
      expect(ele.className).toEqual ' use-my-feature'

    it 'does not append twice', ->
      ele = document.createElement 'div'
      pinball.addCSSClassName('my_feature', ele)
      pinball.addCSSClassName('my_feature', ele)
      expect(ele.className).toEqual ' use-my-feature'

  describe '#removeCSSClassName', ->
    it 'removes it', ->
      ele = document.createElement 'div'
      pinball.addCSSClassName('my_feature', ele)
      pinball.removeCSSClassName('my_feature', ele)
      expect(ele.className).toEqual ''

  describe '#_urlValues', ->
    it 'pulls out the parts', ->
      urlParam = '?pinball=a,b'
      expect(pinball._urlValues(urlParam)).toEqual(['a','b'])

    it 'is empty for blank values', ->
      urlParam = '?pinball'
      expect(pinball._urlValues(urlParam)).toEqual([])

    it 'works with other keys/values', ->
      urlParam = '?foo=bar&pinball=a,b&bar'
      expect(pinball._urlValues(urlParam)).toEqual(['a','b'])

  describe '#activatePermanently', ->
    beforeEach ->
      pinball.resetPermanent()
      pinball.add
        my_feature1: 'inactive'

    it 'accepts a single feature', ->
      pinball.activatePermanently('my_feature1')
      expect(pinball.permanent()).toEqual(['my_feature1'])

    it 'adds it to the list of permanent', ->
      pinball.activatePermanently('my_feature1')
      expect(pinball.permanent()).toEqual(['my_feature1'])

    it 'activates the feature', ->
      pinball.activatePermanently('my_feature1')
      expect(pinball.isActive('my_feature1')).toEqual(true)

    it 'accepts a comma-separated list of features', ->
      pinball.add
        my_feature1: 'inactive'
        my_feature2: 'inactive'
      pinball.activatePermanently('my_feature1,my_feature2')
      expect(pinball.permanent()).toEqual(['my_feature1','my_feature2'])
      expect(pinball.isActive('my_feature1')).toEqual(true)
      expect(pinball.isActive('my_feature2')).toEqual(true)


  describe '#permanent', ->
    beforeEach ->
      pinball.resetPermanent()
      pinball.add
        my_feature: 'inactive'

    it 'is empty by default', ->
      expect(pinball.permanent()).toEqual([])

    it 'builds a list of those permanent', ->
      pinball.activatePermanently('my_feature')
      expect(pinball.permanent()).toEqual(['my_feature'])

    it 'is empty after resetting', ->
      pinball.activatePermanently('my_feature')
      pinball.resetPermanent()
      expect(pinball.permanent()).toEqual([])

  describe '#activateAllPermanent', ->
    beforeEach ->
      pinball.resetPermanent()
      pinball.add
        my_feature: 'inactive'

    it 'is active', ->
      pinball.activatePermanently('my_feature')
      pinball.deactivate 'my_feature'
      pinball.activateAllPermanent()
      expect(pinball.isActive('my_feature')).toEqual(true)
