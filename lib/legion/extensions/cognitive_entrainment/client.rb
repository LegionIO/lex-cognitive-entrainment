# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveEntrainment
      class Client
        include Runners::CognitiveEntrainment

        def initialize(engine: nil)
          @engine = engine || Helpers::EntrainmentEngine.new
        end
      end
    end
  end
end
