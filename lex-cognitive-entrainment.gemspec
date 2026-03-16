# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_entrainment/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-entrainment'
  spec.version       = Legion::Extensions::CognitiveEntrainment::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Cognitive Entrainment'
  spec.description   = 'Inter-agent cognitive rhythm synchronization — entrainment, drift, ' \
                       'and phase-locking for brain-modeled agentic AI'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-entrainment'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = 'https://github.com/LegionIO/lex-cognitive-entrainment'
  spec.metadata['documentation_uri']   = 'https://github.com/LegionIO/lex-cognitive-entrainment'
  spec.metadata['changelog_uri']       = 'https://github.com/LegionIO/lex-cognitive-entrainment'
  spec.metadata['bug_tracker_uri']     = 'https://github.com/LegionIO/lex-cognitive-entrainment/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-cognitive-entrainment.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
