Pod::Spec.new do |s|
  s.name     = 'JPHAsyncOperation'
  s.version  = '1.0'
  s.license  = 'MIT'
  s.summary  = 'An NSOperation subclass and NSOperationQueue category for easy async block operations.'
  s.authors  = { 'Pierre Houston' => 'jpmhouston@gmail.com' }
  s.source   = { :git => 'https://github.com/jpmhouston/JPHAsyncOperation', :tag => "v#{s.version}" }
  s.source_files = 'JPHAsyncOperation.h', 'JPHAsyncOperation.m', 'NSOperationQueue+JPHAsync.h', 'NSOperationQueue+JPHAsync.m'
  s.frameworks = 'Foundation'
  s.requires_arc = true
  s.ios.platform = :ios, '7.0'
  s.osx.platform = :osx, '10.8'
end
