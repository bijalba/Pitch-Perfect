# Pitch-Perfect
Udacity iOS Nanodegree Project 1

-------------------------------------
Description
-------------------------------------

This is an audio app that allows someone to record their voice and play it back in with one of 6 effects.


-------------------------------------
Additional Implementation
-------------------------------------

* Recording is pausable and resumable once paused
* Text labels have been added to the recording and pause buttons
* Two extra effects, echo and reverb added
* A single function for any audio engine effects is used
* Functions created to reduce code repetition


-------------------------------------
Outstanding concerns
-------------------------------------

#1
Even though PlaySoundsViewController.swift is in the right folder in Xcode, it is outside of the Pitch Perfect folder in
the file structure. However, when I try to move it something goes wrong with the view controllers and it hangs after
pressing stop.

#2
I couldn't figure out how to get something like audioPlayerDidFinishPlaying() to work with the audioEngine. I saw
code that had to do with configuring the completionHandler for the schedule and other workarounds, but everything
I tried either made the stop button stop too soon or too late.

#3
It feels clunky to have a single button show and another single button hide. Is there any way to simply change the
image of one button to another image, and have it be the same button? The same goes for the labels that are showing
and hiding. That should be one label that changes content.
