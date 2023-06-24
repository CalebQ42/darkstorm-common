# Darkstorm-Common

A few common widgets and utilities for my apps. Most widgets are meant to be used in particular ways with other Widgets.

## Standalone

* Driver
  * "Easy" to use Google Drive interface.
* DriveQueryBuilder
* UpdatingSwitchTile
  * A SwitchListTile that automatically updates it's value when clicked.
* TopInherit
  * An InheritedWidget for TopResources.
* TopResources
  * A collection of useful variables to use in nearly every part of an app.
  * Includes easy access to an app's main Navigator and Frame.
  * Includes an Observatory.
  * navKey, frameKey, and observatory must be set up properly for all features to work properly.

## TopInherit

The following widgets required a TopInherit ancestor.

* Frame
  * An alternative base UI element to replace app bars and nav drawers.
  * Has support for horizontal and vertical modes with animated transitions when dimensions change.
  * Allows for the top bar to be hidden.
  * To function properly, requires FrameContent as a child.
  * Meant to be used in `MaterialApp.builder`.
* Bottom
  * A model bottom sheet meant to replace dialogs.
  * Prevents the dialog from filling the screen.
  * Integrates well with having a Frame as an ancestor, but does not require it.

## Frame

The following widgets require a Frame ancestor.

* Observatory
  * Requires a properly set up `TopResources.frameKey`
  * A NavigatorObserver that keeps track of the app's current back stack
    * Allows you to know what your current route is, and find a route in it's current stack.
  * Passes route information to Frame.
* FrameContent
  * Simple Scaffold replacement that communicates with a Frame.
* IntroScreen
  * Multi-screen introduction.

## FrameContent

The following widgets require a FrameContent ancestor.

* SpeedDial
  * A Speed Dial fab that blocks interactions with the content when expanded..
    * Still allows access to the Frame's navigation.
