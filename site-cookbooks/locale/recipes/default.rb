unless  ENV["LANGUAGE"] == "en_US.UTF-8" &&
        ENV["LANG"] == "en_US.UTF-8" &&
        ENV["LC_ALL"] == "en_US.UTF-8"

  execute "locale-gen" do
    command "locale-gen en_US.UTF-8"
  end

  execute "dpkg-reconfigure-locales" do
    command "dpkg-reconfigure locales"
  end

  execute "update-locale" do
    command <<-EOH
      locale-gen en_US.UTF-8
      update-locale LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8'
    EOH
  end
end
