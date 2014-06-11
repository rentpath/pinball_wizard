require ['pinball'], (pinball) ->

  beforeEach ->
    pinball.reset()

  describe 'initialize', ->

    it 'is defined', ->
      expect(pinball).toBeDefined()

  describe '#reset', ->

    it 'removes all features', ->
      pinball.add
        a: { available: true,  activatedByDefault: true  }
      pinball.reset()
      expect(pinball.state()).toEqual({})

  describe '#add', ->

    it 'is accessible via #get', ->
      pinball.add
        a: { available: true,  activatedByDefault: true  }

      expect(pinball.get('a')).toEqual
        available: true
        activated: false
        activatedByDefault: true

  describe '#publish', ->
    # triggers available
    # triggers based on url param

  describe '#state', ->
    it 'displays a list based on state', ->
      pinball.add
        a: { available: true,  activatedByDefault: true  }
        b: { available: true,  activatedByDefault: false }
        c: { available: false, activatedByDefault: false }

      expect(pinball.state()).toEqual({
        a: { available: true,  activated: false, activatedByDefault: true  }
        b: { available: true,  activated: false, activatedByDefault: false }
        c: { available: false, activated: false, activatedByDefault: false }
      })

  describe '#activate', ->

    it 'makes an available feature active', ->
      pinball.add
        a: { available: true, activatedByDefault: true  }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        available: true
        activated: true
        activatedByDefault: true

    it 'does not make an unavailable feature active', ->
      pinball.add
        a: { available: false, activatedByDefault: false  }
      pinball.activate 'a'

      expect(pinball.get('a')).toEqual
        available: false
        activated: false
        activatedByDefault: false

  describe '#deactivate', ->

  describe '#activateFromList', ->

  describe '#isActivated', ->

  describe '#subscribe', ->

  describe '#debug', ->


  # Hm, something with require isn't loading jasmine
  jasmine.getEnv().execute()
