# Changelog

## 2.0.13

* Update `googleapis` package constraints

## 2.0.1

* Bottom now obeys TopResource's globalDuration.

## 2.0.0

* Moved Stupid Backend, now called Darkstorm Backend, here instead of a separate library.
  * Count ID is now handled by the library instead of by the Application.
* Organized the components into separate folders (ui, util, drive, and backend)

## 1.0.13

* Fix internet connection status on `readySync`

## 1.0.12

* Update dependencies

## 1.0.11

* Updated dependencies

## 1.0.10

* Allow setting SpeedDial's main fab's child. Defaults to `Icon(Icons.add).

## 1.0.9

* Allow setting alignment of `Bottom` items.

## 1.0.8

* Update depreciated `willPopScope` to `PopScope`.
* Updated deps

## 1.0.7

* Added better handling of full Google Drive. Checks when updating and creating files.

## 1.0.6

* Added handling of Google Drive being full error (`The user's Drive storage quota has been exceeded.`)

## 1.0.5

* Fixed Bottom not updating properly.

## 1.0.4

* Ignore network errors for Driver.

## 1.0.3

* Tweaks to how Driver handles errors.

## 1.0.2

* Changed internet checker to newer library.

## 1.0.1

* Moved SpeedDial to it's own file for organization.
* Renamed fabKey in FrameContent to speedDialKey to better represent what it is
* Renamed `top_inherit.dart` to `top_resources.dart`g

## 1.0.0

* Force horzontal layout on wide screens (>550)
* Account for view padding for Frame.
  * This is particularly an issue on Samsung devices as the view padding includes the status bar.
* Added quicker transitionDuration to TopResources
  * Used mainly for the nav items in Frame when the view size changes.
* Nav items don't change the route if it's the current route

## 1.0.0-pre.18

* Fixed intro pages not updating their contents properly.

## 1.0.0-pre.17

* Don't force disable dialogShow when tapping nav items when dialog is open, just pop.

## 1.0.0-pre.16

* When a Bottom is show, the nav bar is de-expanded.

## 1.0.0-pre.15

* Bottom's constraints have been moved back to content instead of the dialog itself.
  * Moving the constraints to the box itself caused buttons to now show when properly
* Bottom's child is now just added to the list view instead of displayed standalone.
  * Fixes excess whitespace, but might cause some weird scrolling issues. I'll need to test this.
* Fixed some issues with Frame
  * Changing from scrolling to non-scrolling nav items now works better and animates properly
    * Fixes a fairly inconsequential overflow error when switching from a vertical layout that scrolls to horizontal that doesn't
  * FloatingNavItem no longer animates away when switching from vertical to horizontal.
    * This was causing 2 instances of the button showing at once, causing an error since they shared a GlobalKey.
* Moved Nav and FloatingNavItem to their own file instead of being with Frame.

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
