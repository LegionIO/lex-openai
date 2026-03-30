# frozen_string_literal: true

require 'legion/extensions/openai/version'
require 'legion/extensions/openai/helpers/client'
require 'legion/extensions/openai/runners/chat'
require 'legion/extensions/openai/runners/models'
require 'legion/extensions/openai/runners/images'
require 'legion/extensions/openai/runners/audio'
require 'legion/extensions/openai/runners/embeddings'
require 'legion/extensions/openai/runners/files'
require 'legion/extensions/openai/runners/moderations'

module Legion
  module Extensions
    module Openai
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false
    end
  end
end
