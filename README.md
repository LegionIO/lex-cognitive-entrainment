# lex-cognitive-entrainment

Inter-agent cognitive rhythm synchronization for brain-modeled agentic AI in the LegionIO ecosystem.

## What It Does

Entrainment is the phenomenon where two systems synchronize their rhythms through repeated interaction. This extension models that process between agents: two agents form a pairing, and their synchrony score rises with each aligned interaction and falls with each misaligned one. Without interaction, pairings naturally drift back toward independence.

Synchrony is labeled on a five-level scale: `independent`, `drifting`, `partial`, `entrained`, and `locked`. The engine tracks up to 200 live pairings, evicts the least-recently-interacted pair when at capacity, and supports bulk drift operations for idle decay.

## Usage

```ruby
require 'legion/extensions/cognitive_entrainment'

client = Legion::Extensions::CognitiveEntrainment::Client.new

# Create a pairing between two agents in a domain
result = client.create_entrainment_pairing(
  agent_a: 'agent-001',
  agent_b: 'agent-002',
  domain:  'task_planning'
)
pairing_id = result[:pairing_id]

# Record aligned interactions to build synchrony
client.record_entrainment_interaction(pairing_id: pairing_id, aligned: true)
client.record_entrainment_interaction(pairing_id: pairing_id, aligned: true)
client.record_entrainment_interaction(pairing_id: pairing_id, aligned: false)

# Check entrained partners for an agent
client.entrained_partners(agent_id: 'agent-001')
# => { agent_id: 'agent-001', partners: ['agent-002'], count: 1 }

# Run periodic drift and prune cycle
client.update_cognitive_entrainment

# Overall synchrony across all pairings
client.overall_entrainment_level
# => { overall_synchrony: 0.42, entrained_count: 0 }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
