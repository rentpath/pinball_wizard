(function() {
  define(function() {
    return function(ele, pinballQueue, searchQuery) {
      var add, addWithout, added, classNames, entry, feature, featureNames, i, j, k, kebabify, len, len1, len2, matches, ref, ref1, state, storage;
      classNames = [];
      add = function(name) {
        var classToAdd;
        classToAdd = 'use-' + kebabify(name);
        if (!added(name)) {
          return classNames.push(classToAdd);
        }
      };
      added = function(name) {
        var classToCheck;
        classToCheck = 'use-' + kebabify(name);
        return classNames.indexOf(classToCheck) !== -1;
      };
      addWithout = function(name) {
        if (!added(name)) {
          return classNames.push('without-' + kebabify(name));
        }
      };
      kebabify = function(name) {
        return name.split('_').join('-');
      };
      matches = searchQuery.match(/pinball=([a-z-_,]+)/i);
      if (matches && matches.length > 1) {
        featureNames = (matches[1] + '').split(',');
        for (i = 0, len = featureNames.length; i < len; i++) {
          feature = featureNames[i];
          add(feature);
        }
      }
      storage = window.localStorage || {
        setItem: function() {}
      };
      ref = JSON.parse(storage.getItem('pinball_wizard')) || [];
      for (j = 0, len1 = ref.length; j < len1; j++) {
        feature = ref[j];
        add(feature);
      }
      for (k = 0, len2 = pinballQueue.length; k < len2; k++) {
        entry = pinballQueue[k];
        if (!entry.length) {
          continue;
        }
        switch (entry[0]) {
          case 'activate':
            add(entry[1]);
            break;
          case 'add':
            ref1 = entry[1];
            for (feature in ref1) {
              state = ref1[feature];
              if (state === 'active') {
                add(feature);
              } else if (state === 'inactive') {
                addWithout(feature);
              }
            }
        }
      }
      if (ele) {
        ele.className += ' ' + classNames.sort().join(' ');
      }
    };
  });

}).call(this);
