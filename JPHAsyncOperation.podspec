Pod::Spec.new do |s|
  s.name     = 'JPHAsyncOperation'
  s.version  = '1.0.1'
  s.license  = 'MIT'
  s.summary  = 'An NSOperation subclass and NSOperationQueue category for easy async block operations.'
  s.homepage = 'https://github.com/jpmhouston/JPHAsyncOperation'
  s.authors  = { 'Pierre Houston' => 'jpmhouston@gmail.com' }
  s.source   = { :git => 'https://github.com/jpmhouston/JPHAsyncOperation.git', :tag => "v#{s.version}" }
  s.source_files = 'JPHAsyncOperation.h', 'JPHAsyncOperation.m', 'NSOperationQueue+JPHAsync.h', 'NSOperationQueue+JPHAsync.m'
  s.frameworks = 'Foundation'
  s.requires_arc = true
  s.platform = :ios, :osx # don't know if this syntax works, used to get this by omitting platform altogether
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
end
