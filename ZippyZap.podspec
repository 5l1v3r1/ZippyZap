Pod::Spec.new do |s|
    s.name     = 'ZippyZap'
    s.version  = '9.0.0'
    s.license  =  { :type => 'BSD', :file => 'LICENSE' }
    s.summary  = 'A ZIP file I/O library for iOS, macOS and tvOS'
    s.homepage = 'https://github.com/TimOliver/ZippyZap'
    s.authors  = 'Glen Low', 'Tim Oliver'
    
    s.source   = { :git => 'https://github.com/TimOliver/ZippyZap.git', :tag => s.version }
    s.requires_arc = true

    s.ios.deployment_target = '7.0'
    s.osx.deployment_target = '10.10'

    s.libraries = 'z'

    s.source_files = 'ZippyZap/*.{h,cpp,m,mm}'
    s.ios.framework = 'ImageIO'
    s.osx.framework = 'ApplicationServices'
    s.public_header_files = 'ZippyZap/ZippyZap.h', 
                            'ZippyZap/ZZArchive.h', 
                            'ZippyZap/ZZArchiveEntry.h', 
                            'ZippyZap/ZZConstants.h', 
                            'ZippyZap/ZZError.h'
end