<a name="scope"> </a>

This guide is a **demonstration**. It shows how the [TestPlan](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/StructureDefinition-TestPlan.html) resource and [Gherkin](https://cucumber.io/docs/gherkin/) feature files can be used together to declare the conformance tests for the actors of [IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html).

<blockquote class="stu-note">
<strong>This is not an approved IHE test specification.</strong>
It exists to exercise the tooling — the TestPlan resource, the Gherkin scripts and the
packaging of both. The test content is illustrative and has not been run against any
certified system.
</blockquote>

### What is here
<a name="content"> </a>

| | |
| --- | --- |
| [Testing](testing.html) | How the test plans are put together, how the Gherkin scripts are pointed at and packaged, and how they are rendered here. |
| [Artifacts](artifacts.html) | The two TestPlan resources, one per MEOW actor, and the Gherkin scripts they name. |
| [Downloads](downloads.html) | The published package, including the raw `.feature` files under `tests/gherkin/`. |

The two test plans mirror each other across the same transactions:

* **[MEOW Consumer (Client) Test Plan](TestPlan-meow-client-tests.html)** — the system under test initiates every exchange; the test bed plays the Responder and judges what arrives.
* **[MEOW Responder (Server) Test Plan](TestPlan-meow-server-tests.html)** — the test bed originates every request and asserts on the response it gets back.

Both are written for the [Interoperability Test Bed](https://www.itb.ec.europa.eu/docs/guides/latest/).

### Why it is interesting
<a name="why"> </a>

`TestPlan` is not part of the core specification. It was in R6 core through `6.0.0-ballot3` but was removed again for `6.0.0-ballot5`, the version this guide targets, so it comes from the [FHIR Testing IG](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/) package `hl7.fhir.uv.testing`. Building an IG that *uses* a resource type defined outside core is the part this guide exercises, and the [Testing](testing.html) page records what does and does not work.

<a name="navigation"> </a>

The top menu navigates the sections, and a [Table of Contents](toc.html) lists the full content.

<a name="ip"> </a>

### Intellectual Property Considerations

While this implementation guide and the underlying FHIR are licensed as public domain, this guide references terminologies such as LOINC and SNOMED CT which have more restrictive licensing requirements. Implementers should make themselves familiar with the licensing and other constraints of terminologies and other components used as part of their implementation process.

<a name="disclaimer"> </a>

### Disclaimer

The specification documented here is a demonstration, and may not be used for any implementation purposes. It is provided without warranty of completeness or consistency. No liability can be inferred from its use or misuse, or its consequences.
