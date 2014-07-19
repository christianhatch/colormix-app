platform :ios, '7.1'



pod 'FlurrySDK'
pod 'pop'

#debug only
pod 'Tweaks'


post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', '/Users/chatch/Dropbox/Business/YHL/iOS Projects/ColormixProject/Colormix/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end