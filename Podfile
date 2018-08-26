platform :ios, '10.0'
inhibit_all_warnings!
project 'blocko.xcodeproj'

def test_pods
    pod 'Nimble', '~> 7.0.2'
    pod 'Quick', '~> 1.2'
end

target 'blocko' do
    use_frameworks!

    pod 'SnapKit'
    pod 'Alamofire'
    pod 'SwiftLint'
    pod 'R.swift'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'Lockbox'
#    pod 'RealmSwift'
    pod 'ObjectMapper'
    pod 'SDWebImage'
    pod 'Fabric'
    pod 'Crashlytics'

    target 'blockoTests' do
        inherit! :search_paths
        test_pods
    end

end

