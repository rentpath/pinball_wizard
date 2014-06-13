// Generated by CoffeeScript 1.7.1
(function() {
  require(['pinball'], function(pinball) {
    beforeEach(function() {
      pinball.debug();
      return pinball.reset();
    });
    describe('initialize', function() {
      return it('is defined', function() {
        return expect(pinball).toBeDefined();
      });
    });
    describe('#reset', function() {
      return it('removes all features', function() {
        pinball.add({
          a: {}
        });
        pinball.reset();
        return expect(pinball.state()).toEqual({});
      });
    });
    describe('#add', function() {
      it('is available by default', function() {
        pinball.add({
          a: {}
        });
        return expect(pinball.get('a').available).toEqual(true);
      });
      it('is not activeByDefault', function() {
        pinball.add({
          a: {}
        });
        return expect(pinball.get('a').activeByDefault).toEqual(false);
      });
      it('honors available and activeByDefault attributes', function() {
        pinball.add({
          a: {
            available: true,
            activeByDefault: true
          }
        });
        return expect(pinball.get('a')).toEqual({
          name: 'a',
          available: true,
          active: true,
          activeByDefault: true
        });
      });
      it('activates if activeByDefault', function() {
        pinball.add({
          a: {
            activeByDefault: true
          }
        });
        return expect(pinball.isActive('a')).toEqual(true);
      });
      it('does not activate if activeByDefault is false', function() {
        pinball.add({
          a: {
            activeByDefault: false
          }
        });
        return expect(pinball.isActive('a')).toEqual(false);
      });
      return describe('with a url param', function() {
        var originalPathname;
        originalPathname = null;
        beforeEach(function() {
          return originalPathname = window.location.pathname;
        });
        afterEach(function() {
          return window.history.replaceState(null, null, originalPathname);
        });
        it('is not activate when mismatched', function() {
          var urlParam;
          urlParam = '?pinball_foo';
          window.history.replaceState(null, null, window.location.pathname + urlParam);
          pinball.add({
            a: {}
          });
          return expect(pinball.isActive('a')).toEqual(false);
        });
        return it('is activate with a missing url param', function() {
          var urlParam;
          urlParam = '?pinball_a';
          window.history.replaceState(null, null, window.location.pathname + urlParam);
          pinball.add({
            a: {}
          });
          return expect(pinball.isActive('a')).toEqual(true);
        });
      });
    });
    describe('#state', function() {
      return it('displays a list based on state', function() {
        pinball.add({
          a: {
            activeByDefault: true
          },
          b: {},
          c: {
            available: false
          }
        });
        return expect(pinball.state()).toEqual({
          a: {
            name: 'a',
            available: true,
            active: true,
            activeByDefault: true
          },
          b: {
            name: 'b',
            available: true,
            active: false,
            activeByDefault: false
          },
          c: {
            name: 'c',
            available: false,
            active: false,
            activeByDefault: false
          }
        });
      });
    });
    describe('#activate', function() {
      it('makes an available feature active', function() {
        pinball.add({
          a: {
            available: true,
            activeByDefault: true
          }
        });
        pinball.activate('a');
        return expect(pinball.get('a')).toEqual({
          name: 'a',
          available: true,
          active: true,
          activeByDefault: true
        });
      });
      return it('does not make an unavailable feature active', function() {
        pinball.add({
          a: {
            available: false,
            activeByDefault: false
          }
        });
        pinball.activate('a');
        return expect(pinball.get('a')).toEqual({
          name: 'a',
          available: false,
          active: false,
          activeByDefault: false
        });
      });
    });
    describe('#deactivate', function() {
      return it('makes an active feature inactive', function() {
        pinball.add({
          a: {
            available: true,
            activeByDefault: true
          }
        });
        pinball.deactivate('a');
        return expect(pinball.get('a')).toEqual({
          name: 'a',
          available: true,
          active: false,
          activeByDefault: true
        });
      });
    });
    describe('#isActive', function() {
      beforeEach(function() {
        return pinball.add({
          a: {}
        });
      });
      it('is true after activating', function() {
        pinball.activate('a');
        return expect(pinball.isActive('a')).toEqual(true);
      });
      return it('is false if not activated', function() {
        expect(pinball.isActive('a')).toEqual(false);
        return expect(pinball.get('a')).toEqual({
          name: 'a',
          available: true,
          active: false,
          activeByDefault: false
        });
      });
    });
    describe('#subscribe', function() {
      var callback;
      callback = null;
      beforeEach(function() {
        return callback = jasmine.createSpy('callback');
      });
      describe('when the activate callback should be called', function() {
        it('calls after activating', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', callback);
          pinball.activate('a');
          return expect(callback).toHaveBeenCalled();
        });
        it('calls it once on multiple activations', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', callback);
          pinball.activate('a');
          pinball.activate('a');
          pinball.activate('a');
          return expect(callback.calls.count()).toEqual(1);
        });
        it('calls it twice when toggling activations', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', callback);
          pinball.activate('a');
          pinball.deactivate('a');
          pinball.activate('a');
          return expect(callback.calls.count()).toEqual(2);
        });
        it('calls when subscribing then adding an activeByDefault feature', function() {
          pinball.subscribe('a', callback);
          pinball.add({
            a: {
              activeByDefault: true
            }
          });
          return expect(callback).toHaveBeenCalled();
        });
        it('calls when subscribing then adding and then activating a feature', function() {
          pinball.subscribe('a', callback);
          pinball.add({
            a: {}
          });
          pinball.activate('a');
          return expect(callback).toHaveBeenCalled();
        });
        return it('calls when subscribing to an already active feature', function() {
          pinball.add({
            a: {
              activeByDefault: true
            }
          });
          pinball.subscribe('a', callback);
          return expect(callback).toHaveBeenCalled();
        });
      });
      describe('when the activate callback should not be called', function() {
        it('does not call when the feature is missing', function() {
          pinball.subscribe('a', callback);
          pinball.activate('a');
          return expect(callback).not.toHaveBeenCalled();
        });
        return it('does not call when the feature is not available', function() {
          pinball.add({
            a: {
              available: false
            }
          });
          pinball.subscribe('a', callback);
          pinball.activate('a');
          return expect(callback).not.toHaveBeenCalled();
        });
      });
      describe('when the deactivate callback should be called', function() {
        it('calls after deactivate', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', null, callback);
          pinball.activate('a');
          pinball.deactivate('a');
          return expect(callback).toHaveBeenCalled();
        });
        it('calls it once on multiple deactivations', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', null, callback);
          pinball.activate('a');
          pinball.deactivate('a');
          pinball.deactivate('a');
          return expect(callback.calls.count()).toEqual(1);
        });
        it('calls it twice when toggling deactivations', function() {
          pinball.add({
            a: {}
          });
          pinball.subscribe('a', null, callback);
          pinball.activate('a');
          pinball.deactivate('a');
          pinball.activate('a');
          pinball.deactivate('a');
          return expect(callback.calls.count()).toEqual(2);
        });
        it('calls when subscribing, adding adding an activeByDefault then deactivating', function() {
          pinball.subscribe('a', null, callback);
          pinball.add({
            a: {
              activeByDefault: true
            }
          });
          pinball.deactivate('a');
          return expect(callback).toHaveBeenCalled();
        });
        return it('calls when subscribing then adding and then deactivating a feature', function() {
          pinball.subscribe('a', null, callback);
          pinball.add({
            a: {}
          });
          pinball.activate('a');
          pinball.deactivate('a');
          return expect(callback).toHaveBeenCalled();
        });
      });
      describe('when the deactivate callback should not be called', function() {
        return it('does not call when subscribing then adding an activeByDefault feature', function() {
          pinball.subscribe('a', null, callback);
          pinball.add({
            a: {
              activeByDefault: true
            }
          });
          return expect(callback).not.toHaveBeenCalled();
        });
      });
      it('does not call when the feature is missing', function() {
        pinball.subscribe('a', null, callback);
        pinball.activate('a');
        pinball.deactivate('a');
        return expect(callback).not.toHaveBeenCalled();
      });
      return it('does not call when the feature is not available', function() {
        pinball.add({
          a: {
            available: false
          }
        });
        pinball.subscribe('a', null, callback);
        pinball.activate('a');
        pinball.deactivate('a');
        return expect(callback).not.toHaveBeenCalled();
      });
    });
    return jasmine.getEnv().execute();
  });

}).call(this);
