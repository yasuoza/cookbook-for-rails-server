long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

%w{ debian ubuntu }.each do |os|
  supports os
end
