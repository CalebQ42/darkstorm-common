# Changelog

## 1.0.0-pre.14

* When using Bottom, the dialog is now dismissible by tapping on the nav options.
* Bottom's constraints are now applied to the dialog itself instead of the contents.
  * Fixes issues of abundant whitespace after the content.
* FloatingNavItem now properly shows.

## 1.0.0-pre.13

* Removed generic type from TopInherit because it breaks context.getInheritedWidgetOfExactType

## 1.0.0-pre.12

* Added generic type to TopInherit for easier TopResources.of construction

## 1.0.0-pre.11

* Added IntroScreen and IntroPage

## 1.0.0-pre.10

* Tweaked Bottom so content only takes up 65% of the screen instead of 80%
  * 80% was too large when you consider that the 65% is only the content and doesn't include the buttons or padding.

## 1.0.0-pre.9

* Re-worked Bottom to make it more flexible and to prevent infinite height errors.
  * Now works with either child, children, or itemBuilder as the main body is now an AnimatedList
* Fixed issues with Frame not hiding properly.

## 1.0.0-pre.8

* Selection indicator should properly update now.

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
