# Changelog

## 1.0.0-pre.7

* Remove ability to scroll nav items when nav drawer is collapsed when vertical.
  * Also scrolls back to the top when collapsed.

## 1.0.0-pre.6

* Forgot to actually add the improved top nav to the UI (oops).

## 1.0.0-pre.5

* Fixed the top nav item not displaying right.
  * Frame.floatingNav now disappears when the nav drawer is open

## 1.0.0-pre.4

* Use some key trickery to update nav items for Frame. (hopefully this works)

## 1.0.0-pre.3

* TopResources.globalDuration is no longer final so it can be set. (this is the entire reason I seperated TopResources from TopInherit).

## 1.0.0-pre.2

* Changed TopInherit to a seperate class with TopResources as a mixin to hold the actual resources.

## 1.0.0-pre.1

* Initial Release
