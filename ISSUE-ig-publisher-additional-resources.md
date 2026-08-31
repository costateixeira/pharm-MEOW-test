# IG Publisher drops additional-resource elements in a consuming IG

The IG Publisher silently discards every element specific to an *additional
resource* definition when that resource is used in an IG that **consumes** the
defining package, and then reports the `resourceDefinition` marker as missing —
even when the marker is present in the source it just read.

The result is a published resource that looks well-formed but has lost most of
its content. For `TestPlan` that means losing `suite`, and with it
`suite.input.file` — the pointer to the test script the plan exists to declare.

## Environment

| | |
| --- | --- |
| IG Publisher | jar dated 2026-08-27, reports `tool 5.0.0 (3)` |
| IG `fhirVersion` | `6.0.0-ballot5` |
| Dependency | `hl7.fhir.uv.testing: current` → `0.1.0-snapshot1`, built on `6.0.0-ballot3` |
| SUSHI | 3.20.1 |

`TestPlan` was part of R6 core through `6.0.0-ballot3` but was removed again for
`6.0.0-ballot5`. On ballot5 the FHIR Testing IG is therefore the only source for
it, which makes every `TestPlan` instance an additional resource.

## What was built

The example IG declares two `TestPlan` instances, one per IHE PHARM MEOW actor.
Each points at a Gherkin feature file:

```json
"suite": [{
  "name": "IHE MEOW Medication Overview Consumer - client-side conformance",
  "input": [{ "name": "gherkin-script", "file": "meow-client-gherkin-script.feature" }],
  "test": [ ... ]
}]
```

The `.feature` files themselves ship correctly — `path-test` mirrors them into
`package/tests/gherkin/` in the built package. Only the TestPlan's *reference*
to them is lost.

## What happens

Three builds were run against the same publisher, varying where the instance
comes from and whether it carries the marker.

### Build 1 — source as SUSHI produces it

SUSHI cannot emit `resourceDefinition`, because that element is not part of the
`StructureDefinition`:

```
error The element or path you referenced does not exist: resourceDefinition
```

There is no IG-level substitute either: `additional-resource` and
`ig-load-as-resource` in `hl7.fhir.uv.tools` both have context
`StructureDefinition`, so they apply to the IG that *defines* the type, not one
that consumes it.

Publisher result — the resource is truncated:

```
source   fsh-generated/resources/TestPlan-meow-client-tests.json
         url, version, name, title, status, experimental, date, publisher,
         contact, description, purpose, scope, runner, suite

output   output/en/TestPlan-meow-client-tests.json
         resourceType, resourceDefinition, id, language, text, url, version,
         name, title, status, experimental, date, publisher, contact,
         description, jurisdiction, purpose, scope        <- stops at scope
```

`runner`, `mode`, `parameter` and the whole `suite` are gone, with these errors:

```
error  This resource is an additional resource, so must have a resourceDefinition
       of 'http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1'
       VALIDATION_ADDITIONAL_RESOURCE_ABSENT
error  TestPlan.runner: minimum required = 1, but only found 0
       (from http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1)
```

The second error is the tell: `runner` **is** present in the source file. The
publisher cannot see it.

### Build 2 — `resourceDefinition` added to the SUSHI-generated source

The generated resources were patched to carry exactly the value the publisher
asks for, and the publisher was run with `-no-sushi` so nothing regenerated over
the patch. Verified in the source immediately before the run:

```
TestPlan-meow-client-tests.json | resourceDefinition: True | runner: True | suite: True
TestPlan-meow-server-tests.json | resourceDefinition: True | runner: True | suite: True
```

**The output is identical to build 1.** `runner` and `suite` are still dropped,
and the publisher still reports:

```
error  This resource is an additional resource, so must have a resourceDefinition
       of 'http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1'
```

— naming the exact value that is in the file it just read. So supplying the
marker does not help.

### Build 3 — hand-authored instance in `input/resources/`

To rule out any difference between a predefined resource and one SUSHI
generates, the same two instances - `resourceDefinition` included - were placed
directly in `input/resources/` as hand-authored JSON, the FSH removed, and the
publisher run with its normal pipeline (its own SUSHI pass cannot touch a
predefined resource).

Source going in:

```
input/resources/TestPlan-meow-client-tests.json | rd:True runner:True suite:True
input/resources/TestPlan-meow-server-tests.json | rd:True runner:True suite:True
```

**Output identical again** - `runner` and `suite` dropped, same two errors. So
the behaviour does not depend on where the instance comes from, nor on whether
SUSHI was involved at all.

## Summary of the three builds

| Build | Instance source | `resourceDefinition` in source | `runner`/`suite` published | Errors |
| --- | --- | --- | --- | --- |
| 1 | `fsh-generated/` (SUSHI) | no - SUSHI cannot emit it | dropped | 4 |
| 2 | `fsh-generated/`, patched, `-no-sushi` | yes | dropped | 4 |
| 3 | `input/resources/`, hand-authored | yes | dropped | 4 |

## What this suggests

The publisher appears to parse the instance against a model that does not
include the additional resource's definition, discarding both the unknown
elements *and* `resourceDefinition` itself, and only afterwards validates and
finds the marker absent.

Note that the publisher **already knows the correct value** — it writes
`"resourceDefinition": "http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1"`
into the output even in build 1, where nothing in the source supplied it. The
information needed to parse the resource correctly is available; it just isn't
used at parse time. Repairing the output after the elements have been dropped is
what makes the result look self-consistent while being incomplete.

## Suggested fixes

1. Resolve the additional-resource definition at parse time, using the same
   information the publisher already computes for the injection step.
2. Failing that, make the condition fatal rather than element-dropping. A build
   that silently discards most of a resource is worse than one that stops.
3. Independently: SUSHI cannot express `resourceDefinition` at all, so if it is
   to remain required, it needs to be reachable from FSH — or the requirement
   needs to be inferable.

## Related: two definitions share one canonical

`http://hl7.org/fhir/StructureDefinition/TestPlan` resolves to two quite
different shapes depending on FHIR version:

| Source | Shape |
| --- | --- |
| R6 core `6.0.0-ballot3` | `scope.artifact[x]`, `testCase.testRun.script` |
| `hl7.fhir.uv.testing` `0.1.0-snapshot1` | `scope.reference`, `runner`, `mode`, `suite` |

On `6.0.0-ballot3` SUSHI resolves `InstanceOf: TestPlan` to the core definition
and the testing IG's is unreachable; on `6.0.0-ballot5`, where core has no
TestPlan, the testing IG's wins. So the shape an author can write flips with
`fhirVersion`, with no way to disambiguate between them.
