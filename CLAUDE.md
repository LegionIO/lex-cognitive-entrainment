# lex-cognitive-entrainment

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-entrainment`

## Purpose

Models inter-agent cognitive rhythm synchronization. Two agents can form a pairing and, through repeated aligned interactions, build synchrony up to a phase-locked state. Unaligned interactions decouple the pair; idle time causes natural drift. Provides the foundation for coordination detection across mesh-connected agents.

## Gem Info

| Field | Value |
|---|---|
| Gem name | `lex-cognitive-entrainment` |
| Version | `0.1.0` |
| Namespace | `Legion::Extensions::CognitiveEntrainment` |
| Ruby | `>= 3.4` |
| License | MIT |
| GitHub | https://github.com/LegionIO/lex-cognitive-entrainment |

## File Structure

```
lib/legion/extensions/cognitive_entrainment/
  cognitive_entrainment.rb          # Top-level require
  version.rb                        # VERSION = '0.1.0'
  client.rb                         # Client class including runner
  helpers/
    constants.rb                    # Threshold and rate constants
    pairing.rb                      # Pairing value object
    entrainment_engine.rb           # Engine: manages pairings, drift, prune
  runners/
    cognitive_entrainment.rb        # Runner module: 8 public methods
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `MAX_PAIRINGS` | 200 | Hard cap on live pairings; LRU eviction |
| `MAX_SIGNALS` | 500 | Signal buffer ceiling |
| `MAX_HISTORY` | 300 | History ring buffer size |
| `COUPLING_RATE` | 0.1 | Synchrony gained per aligned interaction |
| `DECOUPLING_RATE` | 0.05 | Synchrony lost per misaligned interaction |
| `NATURAL_DRIFT` | 0.02 | Synchrony lost per drift! call |
| `ENTRAINED_THRESHOLD` | 0.7 | Minimum synchrony to consider a pairing entrained |
| `PARTIAL_THRESHOLD` | 0.4 | Minimum for partial entrainment |
| `SYNC_LABELS` | hash | `locked` (0.8+), `entrained`, `partial`, `drifting`, `independent` |
| `SIGNAL_TYPES` | array | `[:rhythm, :timing, :phase, :amplitude]` |

## Helpers

### `Pairing`

Value object representing a directed or bidirectional agent pair.

- `initialize(agent_a:, agent_b:, domain:)` — creates pair with UUID, synchrony starts at `DEFAULT_SYNC` (0.0)
- `interact!(aligned:)` — increments `interaction_count`, adjusts `synchrony` by `COUPLING_RATE` or `-DECOUPLING_RATE`
- `drift!` — reduces synchrony by `NATURAL_DRIFT`
- `entrained?` — `synchrony >= ENTRAINED_THRESHOLD`
- `partially_entrained?` — `synchrony >= PARTIAL_THRESHOLD && < ENTRAINED_THRESHOLD`
- `sync_label` — resolves into `SYNC_LABELS` hash
- `involves?(agent_id)`, `partner_of(agent_id)`
- `to_h` — full serializable snapshot

### `EntrainmentEngine`

Manages the full collection of pairings.

- `create_pairing(agent_a:, agent_b:, domain:)` — deduplicates; evicts oldest if at cap
- `record_interaction(pairing_id:, aligned:)` — delegates to pairing, returns synchrony state
- `pairings_for(agent_id:)` — all pairings involving agent
- `entrained_pairings` — filter to entrained pairs
- `entrained_partners(agent_id:)` — agent IDs of entrained partners
- `strongest_pairings(limit: 5)` — top N by synchrony
- `by_domain(domain:)` — filter by domain
- `overall_entrainment` — mean synchrony across all pairings
- `drift_all` — applies `drift!` to every pairing
- `prune_independent` — removes pairings at synchrony <= 0.02

### `Constants`

Module of frozen constants included into `Pairing` and `EntrainmentEngine`.

## Runners

**Module**: `Legion::Extensions::CognitiveEntrainment::Runners::CognitiveEntrainment`

| Method | Key Args | Returns |
|---|---|---|
| `create_entrainment_pairing` | `agent_a:`, `agent_b:`, `domain:` | `{ success:, pairing_id:, synchrony: }` |
| `record_entrainment_interaction` | `pairing_id:`, `aligned:` | `{ success:, synchrony:, entrained:, sync_label: }` |
| `pairings_for_agent` | `agent_id:` | `{ pairings: [...], count: }` |
| `entrained_partners` | `agent_id:` | `{ partners: [...], count: }` |
| `strongest_entrainment_pairings` | `limit: 5` | `{ pairings: [...] }` |
| `domain_entrainment` | `domain:` | `{ pairings: [...] }` |
| `overall_entrainment_level` | — | `{ overall_synchrony:, entrained_count: }` |
| `update_cognitive_entrainment` | — | `{ pruned: }` — drifts all, prunes independent |
| `cognitive_entrainment_stats` | — | engine `to_h` summary |

Private: `engine` — memoized `EntrainmentEngine` instance.

## Integration Points

- **`lex-mesh`**: Entrainment can be used to assess whether two mesh-registered agents have developed sufficient synchrony for coordinated action. Entrainment does not depend on mesh directly.
- **`lex-tick`**: Could be wired into the `action_selection` phase via `lex-cortex` to prioritize collaboration with highly entrained partners.
- **`lex-trust`**: Entrainment measures rhythmic synchrony; trust measures reliability. High entrainment alone does not imply trust. Complementary signals.

## Development Notes

- `Pairing` deduplication is bidirectional: `(agent_a, agent_b)` and `(agent_b, agent_a)` in the same domain resolve to the same pairing.
- The engine evicts the pairing with the oldest `last_interaction_at` when at `MAX_PAIRINGS`; this is LRU-style, not weakest-synchrony.
- `SIGNAL_TYPES` constant is defined but not currently enforced in the runner; it documents the intended signal taxonomy.
- In-memory only. No persistence. Process restart clears all pairings.

---

**Maintained By**: Matthew Iverson (@Esity)
