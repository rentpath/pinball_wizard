define ['pinball_wizard'], (pinball) ->

  beforeEach ->
    pinball.reset()
    document.documentElement.className = ''

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

    it 'adds use-feature class to css', ->
      pinball.add
        feature_a: 'inactive'
      pinball.activate 'feature_a'
      expect(document.documentElement.className).toEqual(' use-feature-a')

    it 'removes without-feature', ->
      document.documentElement.className = 'foo without-feature-a bar'
      pinball.add
        feature_a: 'inactive'
      pinball.activate 'feature_a'
      expect(document.documentElement.className).toMatch(/foo\s+bar\s+use-feature-a/)

  describe '#deactivate', ->
    it 'makes an active feature inactive', ->
      pinball.add
        a: 'active'
      pinball.deactivate 'a'

      expect(pinball.get('a')).toEqual('inactive')

    it 'adds without-feature class to css', ->
      pinball.add
        feature_a: 'active'
      pinball.deactivate 'feature_a'
      expect(document.documentElement.className).toEqual(' without-feature-a')

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

    it 'builds the name with a custom prefix', ->
      expect(pinball.cssClassName('my_feature', 'without-')).toEqual 'without-my-feature'

  describe '#addCSSClassName', ->
    it 'appends', ->
      ele = document.createElement 'div'
      pinball.addCSSClassName('use-my-feature', ele)
      expect(ele.className).toEqual ' use-my-feature'

    it 'does not append twice', ->
      ele = document.createElement 'div'
      pinball.addCSSClassName('use-my-feature', ele)
      pinball.addCSSClassName('use-my-feature', ele)
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
        my_feature_one: 'inactive'

    it 'accepts a single feature', ->
      pinball.activatePermanently('my_feature_one')
      expect(pinball.permanent()).toEqual(['my_feature_one'])

    it 'adds it to the list of permanent', ->
      pinball.activatePermanently('my_feature_one')
      expect(pinball.permanent()).toEqual(['my_feature_one'])

    it 'activates the feature', ->
      pinball.activatePermanently('my_feature_one')
      expect(pinball.isActive('my_feature_one')).toEqual(true)

    it 'accepts a comma-separated list of features', ->
      pinball.add
        my_feature_one: 'inactive'
        my_feature_two: 'inactive'
      pinball.activatePermanently('my_feature_one', 'my_feature_two')
      expect(pinball.permanent()).toEqual(['my_feature_one','my_feature_two'])
      expect(pinball.isActive('my_feature_one')).toEqual(true)
      expect(pinball.isActive('my_feature_two')).toEqual(true)


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
