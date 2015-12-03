# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Feedings' do
  pod 'Bond', '~> 4.2'
  pod 'Parse', '~> 1.9.1'
  pod 'Colortools'
  pod 'DZNEmptyDataSet', '~> 1.7.2'
end

def testing_pods
  pod 'Quick', '~> 0.8'
  pod 'Nimble', '~> 3.0.0'
end

target 'FeedingsTests' do
  testing_pods
end

target 'FeedingsUITests' do
  testing_pods
end

