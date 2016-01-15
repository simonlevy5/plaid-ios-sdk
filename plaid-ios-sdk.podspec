Pod::Spec.new do |s|
  s.name             = "plaid-ios-sdk"
  s.version          = "0.3.4"
  s.summary          = "iOS SDK for Plaid"

  s.homepage         = "https://github.com/vouch/plaid-ios-sdk"
  s.license          = 'MIT'
  s.author           = { "Simon Levy" => "simon@vouch.com", "Andres Ugarte" => "andres@vouch.com" }
  s.source           = { :git => "https://github.com/vouch/plaid-ios-sdk.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.resource_bundle = { 'PLDResources' => ['Plaid/Resources/Strings/*.strings'] }
  s.source_files = 'Plaid/Classes/**/*'
  s.public_header_files = 'Plaid/Classes/*.h'
end
