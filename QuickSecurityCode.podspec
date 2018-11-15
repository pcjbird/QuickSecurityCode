Pod::Spec.new do |s|
    s.name             = "QuickSecurityCode"
    s.version          = "1.0.3"
    s.summary          = "A security/verify code input control. 一个4位或6位数字的安全码/验证码输入控件。"
    s.description      = <<-DESC
    A security/verify code input control. 一个安全码/验证码输入控件，支持4位或6位的安全码/验证码。
    DESC
    s.homepage         = "https://github.com/pcjbird/QuickSecurityCode"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QuickSecurityCode.git", :tag => s.version.to_s}
    s.social_media_url = 'http://www.lessney.com'
    s.requires_arc     = true
    s.documentation_url = 'https://github.com/pcjbird/QuickSecurityCode/blob/master/README.md'
    s.screenshot       = 'https://github.com/pcjbird/QuickSecurityCode/blob/master/logo.png'

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics'
#s.preserve_paths   = ''
    s.source_files     = 'QuickSecurityCode/*.{h,m}'
    s.public_header_files = 'QuickSecurityCode/QuickSecurityCode.h'

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
