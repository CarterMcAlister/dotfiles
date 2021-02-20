#!/bin/bash

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show only open applications in the Dock
defaults write com.apple.dock static-only -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Set Dark Theme to Dock & Fullscreen
# defaults write NSGlobalDomain AppleInterfaceStyle Dark;

# Remove the auto-hiding Dock delay
# defaults write com.apple.Dock autohide-delay -float 0

# Set the icon size of Dock items to 36 pixels
# defaults write com.apple.dock tilesize -int 36

# Don’t animate opening applications from the Dock
# defaults write com.apple.dock launchanim -bool false

# Removed genie animation
# defaults write com.apple.dock mineffect suck;

# Removes bouncing animation
# defaults write com.apple.dock no-bouncing -bool true

# Enable highlight hover effect for the grid view of a stack (Dock)
# defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Speed up Mission Control animations
# defaults write com.apple.dock expose-animation-duration -float 0.1

# Remove All Apps From The Dock In OS X
# defaults write com.apple.dock persistent-apps -array

killall Dock
