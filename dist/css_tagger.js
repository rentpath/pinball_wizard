(function() {
  define(function() {
    return function(ele, pinballQueue, searchQuery) {
      var add, classNames, entry, feature, featureNames, i, j, k, len, len1, len2, matches, ref, ref1, state, storage;
      classNames = [];
      add = function(name) {
        return classNames.push('use-' + name.split('_').join('-'));
      };
      for (i = 0, len = pinballQueue.length; i < len; i++) {
        entry = pinballQueue[i];
        if (!entry.length) {
          continue;
        }
        switch (entry[0]) {
          case 'activate':
            add(entry[1]);
            break;
          case 'add':
            ref = entry[1];
            for (feature in ref) {
              state = ref[feature];
              if (state === 'active') {
                add(feature);
              }
            }
        }
      }
      matches = searchQuery.match(/pinball=([a-z-_,]+)/i);
      if (matches && matches.length > 1) {
        featureNames = (matches[1] + '').split(',');
        for (j = 0, len1 = featureNames.length; j < len1; j++) {
          feature = featureNames[j];
          add(feature);
        }
      }
      storage = window.localStorage || {
        setItem: function() {}
      };
      ref1 = JSON.parse(storage.getItem('pinball_wizard')) || [];
      for (k = 0, len2 = ref1.length; k < len2; k++) {
        feature = ref1[k];
        add(feature);
      }
      if (ele) {
        ele.className += ' ' + classNames.join(' ');
      }
    };
  });

}).call(this);
