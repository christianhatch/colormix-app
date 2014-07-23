platform :ios, '7.1'

inhibit_all_warnings!


#pod 'FlurrySDK'
pod 'pop'
pod 'Parse-iOS-SDK'

#debug only
pod 'Tweaks'


post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', '/Users/chatch/Dropbox/Business/KnotLabs/iOS Projects/ColormixProject/Colormix/Colormix/Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end