# v1.0.0
* [feature] Now adds`without-` classes to inactive features to support better CSS partitioning between features and production code. 

# v0.4.2
* [feature] `#activatePermanently` now supports multiple features: `('feature1', 'feature2'...)` 

# v0.4.1
* [feature] CSS tagger honors permanent features and adds the
  appropriate CSS class.

[Compare v0.4.0..v0.4.1](https://github.com/primedia/pinball_wizard/compare/v0.4.0...v0.4.1)

# v0.4.0
* [feature] Added `#activatePermanently('feature_name')` to
  activate features across URLs. Stored in `localStorage`
* [feature] Added `#resetPermanent` which clears all permanent.
* [feature] Added `#permanent` which lists out features turned on.

[Compare v0.3.0..v0.4.0](https://github.com/primedia/pinball_wizard/compare/v0.3.0...v0.4.0)

# v0.3.0
* [feature] Automatically add and remove CSS class `.use-{feature-name}` to `<html>` as features are enabled and disabled.
* [feature] Switch to karma for the test runner.
* [deprecated] Removed `?pinball_feature_name` query param

[Compare v0.2.0..v0.3.0](https://github.com/primedia/pinball_wizard/compare/v0.2.0...v0.3.0)
