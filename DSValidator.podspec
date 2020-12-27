Pod::Spec.new do |s|
  s.name         = "DSValidator"
  s.version      = "0.2.4"
  s.summary      = "Custom models rule based validation"

  s.description  = <<-DESC
        Custom models(struct, class) rule based validation. Supports optional values.
                   DESC

  s.homepage     = "https://github.com/dmitrysimkin/DSValidator"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Simkin Dmitry" => "dmitry.simkin@mail.ru" }
  s.platform     = :ios, "10.3"
  s.source       = { :git => "https://github.com/dmitrysimkin/DSValidator.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Sources/**/*.{swift}"
  s.swift_version = '5'
end
