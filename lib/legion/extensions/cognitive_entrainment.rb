# frozen_string_literal: true

require 'legion/extensions/cognitive_entrainment/version'
require 'legion/extensions/cognitive_entrainment/helpers/constants'
require 'legion/extensions/cognitive_entrainment/helpers/pairing'
require 'legion/extensions/cognitive_entrainment/helpers/entrainment_engine'
require 'legion/extensions/cognitive_entrainment/runners/cognitive_entrainment'
require 'legion/extensions/cognitive_entrainment/client'

module Legion
  module Extensions
    module CognitiveEntrainment
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
