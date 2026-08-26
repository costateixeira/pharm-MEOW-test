<a name="scope"> </a>

### Testing the MEOW client

This guide declares its tests using the [TestPlan](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/StructureDefinition-TestPlan.html) resource, which comes from the [FHIR Testing IG](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/) (package `hl7.fhir.uv.testing`).

TestPlan is not in the core specification. It was part of R6 core up to `6.0.0-ballot3`, but was taken out again for `6.0.0-ballot5` — the version this guide is built on. TestPlan, TestScript and TestReport now live only in the FHIR Testing IG, which carries *"the latest definitions of the R6 resources until they are considered stable"*. Depending on that package is therefore the only way to have a TestPlan at all:

```yaml
dependencies:
  hl7.fhir.uv.testing: current
```

<blockquote class="stu-note">
<strong>This is a demonstration artifact.</strong>
The test plans below are samples showing how the mechanism works. They are not approved
IHE test specifications, and the assertions have not been executed against any real system.
</blockquote>

<a name="plan"> </a>

### The test plans

There is one test plan per MEOW actor. Each `scope` names the actor's CapabilityStatement — *what is under test* — rather than the profiles the tests happen to touch; those appear in the assertions instead.

| Test plan | Actor under test | Covers |
| --------- | ---------------- | ------ |
| [MEOW Consumer (Client) Test Plan](TestPlan-meow-client-tests.html) | [Medication Overview Consumer](https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement-MedicationOverviewConsumer.html) | The client builds conformant PHARM-11 queries, and any overview it submits conforms to the profile. |
| [MEOW Responder (Server) Test Plan](TestPlan-meow-server-tests.html) | [Medication Overview Responder](https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement-MedicationOverviewResponder.html) | The server answers PHARM-11 correctly, refuses an unscoped query, and returns a conformant document for PHARM-12. |

The two are mirror images: for the client the system under test initiates every exchange and the test bed plays the Responder; for the server the test bed originates every request and asserts on the response it gets back.

The Responder plan splits its tests into one suite per transaction — PHARM-11 and PHARM-12 — matching the one-transaction-per-scenario structure of its Gherkin script. The PHARM-12 suite is marked with the `document-option` mode, so a Responder that does not claim the Document Option skips it:

| Mode | Applies to |
| ---- | ---------- |
| `required` | Every Medication Overview Responder. |
| `document-option` | Responders claiming the Document Option (PHARM-12). |

`runner` names the tool that executes the tests — here the [Interoperability Test Bed](https://www.itb.ec.europa.eu/docs/guides/latest/).

<a name="gherkin"> </a>

### The Gherkin feature file

The executable test cases are written in [Gherkin](https://cucumber.io/docs/gherkin/) and live in the IG source under `input/testing/gherkin/` — one feature file per actor, `meow-client-gherkin-script.feature` and `meow-server-gherkin-script.feature`.

The feature file ships **as Gherkin, not as a FHIR resource**. The `path-test` parameter mirrors the test tree into the published package:

```
package/tests/gherkin/meow-client-gherkin-script.feature
package/tests/gherkin/meow-server-gherkin-script.feature
```

That is what a test runner consumes. The TestPlan points at it from `suite.input.file`, and the runner resolves that name against the package's test root:

```
* suite
  * input
    * name = "gherkin-script"
    * file = "meow-client-gherkin-script.feature"
```

Each `suite.test` corresponds to one `Scenario:` in that feature file, matched by its `tc-meow-client-NNN` / `tc-meow-server-NNN` identifier. The TestPlan carries the planning view — what is in scope, what must hold for a test to pass — while the feature file carries the steps the runner executes.

<a name="rendering"> </a>

#### Rendering the script on this site

The raw `.feature` file travels in the package but is not browsable on the IG website. To also show it here, the script is additionally carried as a `Binary` whose `data` uses the publisher's `ig-loader-` prefix to inline the file's contents at build time:

> **[MEOW Client Gherkin Script](Binary-meow-client-gherkin-script.html)**
>
> **[MEOW Server Gherkin Script](Binary-meow-server-gherkin-script.html)**

```
Instance: meow-client-gherkin-script
InstanceOf: Binary
Usage: #definition
* language = #en
* contentType = #text/x-gherkin
* data = "ig-loader-meow-client-gherkin-script.feature"
```

For it to render as highlighted Gherkin rather than as raw data, the IG's entry for that Binary carries the `implementationguide-resource-format` extension, after which the renderer emits `<pre class="gherkin language-gherkin">` for the template's Prism.js to highlight.

These Binaries are presentational only. Nothing in either TestPlan references them — the link is the filename alone — and removing them would cost these rendered pages and nothing else.
