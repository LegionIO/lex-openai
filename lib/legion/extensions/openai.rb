# frozen_string_literal: true

require 'legion/extensions/openai/version'

module Legion
  module Extensions
    module Openai
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
