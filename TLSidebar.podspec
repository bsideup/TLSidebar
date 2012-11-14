Pod::Spec.new do |s|
  s.name     = 'TLSidebar'
  s.version  = '0.0.1'
  s.platform = :ios, '5.0'
  s.license  = {:type => 'Custom', :text => 'Copyright (C) 2012 Sergey Egorov' }
  s.summary  = 'Another Facebook-like Sidebar fully compatible with Storyboard and ARC.'
  s.homepage = 'https://github.com/bsideup/TLSidebar'
  s.author   = { 'Sergey Egorov' => 'bsideup@gmail.com' }
  s.source   = { :git => 'https://github.com/bsideup/TLSidebar.git',
		 :commit => 'HEAD' }

  s.source_files = 'TLSidebar/*.{h,m}'
  s.requires_arc = true
end
