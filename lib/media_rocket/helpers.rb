helpers = Pathname(__FILE__).dirname.expand_path / "helpers"
require helpers / "content"
require helpers / "form"

module MediaRocket
  module Helpers
    def self.setup
      [Content, Form].each do |helper|
        Merb::GlobalHelpers.send(:include, helper)
      end
    end
  end
end
