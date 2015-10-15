define ->

  # Add .use-{feature-name} to <html> right away to prevent flickering.
  # Works with ?pinball=feature_name and activated via optimizely.

  # NOTE: underscores are converted to -. e.g. my_feature -> use-my-feature

  # This component is designed to be minified and put in an inline <script> in
  # the document <head>. Above CSS (so that it runs right away).

  # Usage
  # <script type="text/javascript">
  #  (
  #    function (...) { # minified script }
  #  )(document.documentElement, window.pinball, , window.location.search)
  # </script>

  (ele, pinballQueue, searchQuery) ->
    classNames = []

    add = (name) ->
      classNames.push 'use-' + name.split('_').join('-')

    # Activated by the queue
    for entry in pinballQueue
      continue unless entry.length

      switch entry[0]
        when 'activate'
          add entry[1]

        when 'add'
          for feature, state of entry[1]
            add feature if state == 'active'

    # Activated by the URL
    matches = searchQuery.match(/pinball=([a-z-_,]+)/i)
    if matches && matches.length > 1
      featureNames = (matches[1] + '').split(',')

      for feature in featureNames
        add feature


    # Activated permanently
    storage = window.localStorage or { setItem: -> }
    for feature in (JSON.parse(storage.getItem('pinball_wizard')) or [])
      add feature

    ele.className += ' ' + classNames.join(' ') if ele

    return
