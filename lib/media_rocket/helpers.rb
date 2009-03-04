helpers = Pathname(__FILE__).dirname.expand_path / "helpers"
require helpers / "assets"
require helpers / "content"
require helpers / "form"
require helpers / "widgets" if Merb.const_defined? :Webbastic

module MediaRocket
  module Helpers
    def self.setup
      [Assets, Content, Form].each do |helper|
        ::Merb::GlobalHelpers.send(:include, helper)
      end
      
      ::Merb::GlobalHelpers.send(:include, Widget) if Merb.const_defined? :Webbastic
    end
  end
end