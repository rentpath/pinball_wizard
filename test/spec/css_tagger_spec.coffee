define ['css_tagger'], (tagger) ->

  describe 'css_tagger', ->
    it 'should add classes from the pinball async function queue', ->
      ele = document.createElement 'div'
      pinballQueue = [
        ['activate','my_feature']
      ]

      tagger ele, pinballQueue, ''
      expect(ele.className).toEqual ' use-my-feature'

    it 'should add classes from query params', ->
      ele = document.createElement 'div'
      tagger ele, [], '?pinball=feature_a,feature_b&other=param'
      expect(ele.className).toEqual ' use-feature-a use-feature-b'

    it 'should not interfere with existing class names', ->
      ele = document.createElement 'div'
      ele.className = 'foo-bar'
      tagger ele, [], '?pinball=feature_a,feature_b&other=param'
      expect(ele.className).toEqual 'foo-bar use-feature-a use-feature-b'

    it 'should add classes from active and inactive pinball features', ->
      ele = document.createElement 'div'
      pinballQueue = [
        [
          'add'
          feature_a: 'active'
          feature_b: 'inactive'
          feature_c: 'active'
        ]
      ]

      tagger ele, pinballQueue, ''
      expect(ele.className).toEqual ' use-feature-a use-feature-c without-feature-b'

    it 'should add classes from queue and query params', ->
      ele = document.createElement 'div'
      pinballQueue = [
        [
          'add'
          feature_a: 'active'
          feature_d: 'inactive'
        ],
        ['activate', 'feature_b'],
        ['something-odd']
      ]

      tagger ele, pinballQueue, '?pinball=feature_c'
      expect(ele.className).toEqual ' use-feature-a use-feature-b use-feature-c without-feature-d'

    it 'should add classes from the permanent storage', ->
      ele = document.createElement 'div'
      window.localStorage.setItem 'pinball_wizard', JSON.stringify(['feature_a','feature_b'])
      pinballQueue = [
        [
          'add'
          feature_c: 'active'
          feature_d: 'inactive'
        ]
      ]

      tagger ele, pinballQueue, ''
      expect(ele.className).toEqual ' use-feature-a use-feature-b use-feature-c without-feature-d'

      # Cleanup
      window.localStorage.setItem 'pinball_wizard', null

    it 'should not add any when permanent storage is null', ->
      ele = document.createElement 'div'
      window.localStorage.setItem 'pinball_wizard', null

      tagger ele, [], ''
      expect(ele.className).toEqual ''
