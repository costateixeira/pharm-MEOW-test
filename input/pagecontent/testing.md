<a name="scope"> </a>

### Testing the MEOW client

This guide declares its tests using the [TestPlan](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/StructureDefinition-TestPlan.html) resource. TestPlan is not part of the FHIR R4 core specification: it is one of the *R6 Additional Resources* published by the [FHIR Testing IG](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/) (package `hl7.fhir.uv.testing`), which is designed to be usable from an implementation guide built on any FHIR version. This IG therefore declares a dependency on that package, and the TestPlan instance carries a `resourceDefinition` element pointing at the resource definition it conforms to.

<blockquote class="stu-note">
<strong>This is a demonstration artifact.</strong>
The test plan below is a sample showing how the mechanism works. It is not an approved
IHE test specification, and the assertions have not been executed against any real system.
</blockquote>

<a name="plan"> </a>

### The test plan

[MEOW Consumer (Client) Test Plan](TestPlan-meow-client-tests.html) declares the tests for the **Medication Overview Consumer** actor — the *MEOW client* — defined in [IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html).

Its `scope` is the actor's CapabilityStatement, [Medication Overview Consumer](https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement-MedicationOverviewConsumer.html) — the system role being tested. Scope names *what is under test*, not the profiles the tests happen to touch; the MedicationTreatmentLine and Medication Overview Bundle profiles appear in the assertions instead.

The plan defines three `mode` codes. A runner is told which of them apply to the system under test, and skips the tests that do not:

| Mode | Applies to |
| ---- | ---------- |
| `required` | Every Medication Overview Consumer. |
| `document-option` | Consumers claiming the Document Option (PHARM-12). |
| `optional` | Capabilities a Consumer may support; skipped when not claimed. |

<a name="gherkin"> </a>

### The Gherkin feature file

The executable test cases are written in [Gherkin](https://cucumber.io/docs/gherkin/) and live in the IG source at `input/testing/gherkin/meow-client-gherkin-script.feature`.

The feature file ships **as Gherkin, not as a FHIR resource**. The `path-test` parameter mirrors the test tree into the published package:

```
package/tests/gherkin/meow-client-gherkin-script.feature
```

That is what a test runner consumes. The TestPlan names the file as the `input` of its suite, and the runner resolves that name against the package's test root:

```json
"suite" : [{
  "name" : "MEOW Consumer retrieves a patient's medication overview",
  "input" : [{
    "name" : "gherkin-script",
    "file" : "meow-client-gherkin-script.feature"
  }],
  ...
}]
```

Each `suite.test` in the TestPlan corresponds one-to-one, by name, to a `Scenario:` in the feature file. The TestPlan carries the planning view — what is in scope, which mode a test belongs to, what must hold for it to pass — while the feature file carries the steps a Cucumber-style runner executes. Parameters written as `<name>` in the steps are bound from `TestPlan.parameter` and `TestPlan.suite.test.parameter`.

<a name="rendering"> </a>

#### Rendering the script on this site

The raw `.feature` file travels in the package but is not browsable on the IG website. To also show it here, the script is additionally carried as a `Binary` whose `data` uses the publisher's `ig-loader-` prefix to inline the file's contents at build time:

> **[MEOW Client Gherkin Script](Binary-meow-client-gherkin-script.html)**

```
Instance: meow-client-gherkin-script
InstanceOf: Binary
Usage: #definition
* language = #en
* contentType = #text/x-gherkin
* data = "ig-loader-meow-client-gherkin-script.feature"
```

For it to render as highlighted Gherkin rather than as raw data, the IG's entry for that Binary carries the `implementationguide-resource-format` extension, after which the renderer emits `<pre class="gherkin language-gherkin">` for the template's Prism.js to highlight.

This Binary is presentational only. Nothing in the TestPlan references it — the link between the two is the filename alone — and removing it would cost this rendered page and nothing else.

<a name="running"> </a>

### Running the tests

`TestPlan.runner` is a required element: it names the documentation for the tool that knows how to execute these tests. This plan points at a Cucumber-style Gherkin runner, and uses `gherkin/scenario` as the `operation` code on each test. Substitute the runner and operation codes of whichever harness you actually use.
