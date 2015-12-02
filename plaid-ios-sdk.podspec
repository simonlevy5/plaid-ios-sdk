Pod::Spec.new do |s|
  s.name             = "plaid-ios-sdk"
  s.version          = "0.2.0"
  s.summary          = "iOS SDK for Plaid"

  s.homepage         = "https://github.com/vouch/plaid-ios-sdk"
  s.license          = 'MIT'
  s.author           = { "Simon Levy" => "simon@vouch.com" }
  s.source           = { :git => "https://github.com/vouch/plaid-ios-sdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Plaid/**/*'
  s.public_header_files = 'Plaid/*.h'
end
