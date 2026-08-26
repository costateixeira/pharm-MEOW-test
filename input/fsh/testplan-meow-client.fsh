Instance: meow-client-tests
InstanceOf: TestPlan
Usage: #definition
Title: "MEOW Consumer (Client) Test Plan"
Description: "Sample test plan for the Medication Overview Consumer actor (the MEOW client) of IHE PHARM MEOW."

// NOTE: TestPlan is not an R4 core resource - it is an R6 Additional Resource
// from hl7.fhir.uv.testing. The published examples carry a "resourceDefinition"
// element naming the definition they conform to, but that element is not part of
// the StructureDefinition, so FSH cannot express it and SUSHI rejects it.
// The testing IG's own source examples do not set it either - the publisher adds
// it on output - so we rely on the same behaviour here.

* language = #en
* url = "http://example.com/fhir/example/TestPlan/meow-client-tests"
* version = "1.0.0"
* name = "MEOWClientTestPlan"
* title = "MEOW Consumer (Client) Test Plan"
* status = #draft
* experimental = true
* date = "2026-08-25"
* publisher = "My Organization"
* contact.name = "Bob Smith"
* contact.telecom.system = #email
* contact.telecom.value = "bobsmith@example.com"
* contact.telecom.use = #work

* description = """
Sample test plan for the **Medication Overview Consumer** actor (the *MEOW client*) defined by the
[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide.

The test cases are specified as a [Gherkin](https://cucumber.io/docs/gherkin/) feature file, which ships as
Gherkin in the published package under `tests/gherkin/` and is named from `suite.input.file` below. Each
`suite.test` in this resource corresponds one-to-one to a `Scenario:` in that feature file, matched by name.

This is a demonstration artifact: it exists to show how the `TestPlan` resource from the
[FHIR Testing IG](https://build.fhir.org/ig/HL7/fhir-testing-ig/en/) can be used to declare the tests for an
IHE actor. The system under test is the **client**, so the runner drives the client and observes the requests
it issues against a reference Responder.
"""
* purpose = "To declare, in a machine-readable and runnable form, which behaviours a system claiming conformance to the MEOW Medication Overview Consumer actor must demonstrate."

// Scope is the actor under test - its CapabilityStatement - not the profiles
// the tests happen to touch.
* scope.reference = "https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewConsumer"
* scope.description = "The Medication Overview Consumer (MEOW client) actor - the system under test."

* runner = "https://cucumber.io/docs/guides/overview/"

* mode[0].code = "required"
* mode[=].description = "Tests every Medication Overview Consumer must pass."
* mode[+].code = "document-option"
* mode[=].description = "Tests that only apply to a Consumer that claims the Document Option (PHARM-12)."
* mode[+].code = "optional"
* mode[=].description = "Tests for capabilities the Consumer may support; skipped when not claimed."

* parameter[0].name = "server-base"
* parameter[=].valueUri = "http://example.org/meow-reference-responder/fhir"
* parameter[+].name = "patient-id"
* parameter[=].valueString = "meow-test-patient-1"

* suite.name = "MEOW Consumer retrieves a patient's medication overview"
* suite.description = "Maps to the Feature of the same name in meow-client-gherkin-script.feature. The Background steps of that Feature are the common set-up for every test in this suite."
* suite.input.name = "gherkin-script"
* suite.input.file = "meow-client-gherkin-script.feature"

* suite.test[0].name = "Query the medication treatment lines for a patient"
* suite.test[=].description = "PHARM-11: the client issues a patient-scoped MedicationStatement search and handles the searchset it gets back."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #required
* suite.test[=].assertion[0].severity = #error
* suite.test[=].assertion[=].human = "When the client searches for MedicationStatement with parameter 'patient' set to <patient-id>, then the response status is 200 and the response is a Bundle of type searchset."
* suite.test[=].assertion[+].severity = #error
* suite.test[=].assertion[=].expression.language = #text/fhirpath
* suite.test[=].assertion[=].expression.expression = "Bundle.entry.resource.ofType(MedicationStatement).all(meta.profile contains 'https://profiles.ihe.net/PHARM/MEOW/StructureDefinition/MedicationTreatmentLine')"
* suite.test[=].assertion[=].human = "Every returned MedicationStatement conforms to the MedicationTreatmentLine profile."

* suite.test[+].name = "Restrict the overview to currently active treatment lines"
* suite.test[=].description = "PHARM-11 with the status search parameter."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #required
* suite.test[=].assertion.severity = #error
* suite.test[=].assertion.expression.language = #text/fhirpath
* suite.test[=].assertion.expression.expression = "Bundle.entry.resource.ofType(MedicationStatement).all(status = 'active')"
* suite.test[=].assertion.human = "Every entry returned for status=active has status 'active'."

* suite.test[+].name = "Resolve the medicinal product referenced by a treatment line"
* suite.test[=].description = "PHARM-11 with _include=MedicationStatement:medication - the client must be able to resolve the medicinal product it displays."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #required
* suite.test[=].assertion.severity = #error
* suite.test[=].assertion.expression.language = #text/fhirpath
* suite.test[=].assertion.expression.expression = "Bundle.entry.where(search.mode = 'include').exists()"
* suite.test[=].assertion.human = "The Bundle contains at least one included Medication, and no medicationReference is left unresolved."

* suite.test[+].name = "Incrementally synchronise the overview"
* suite.test[=].description = "PHARM-11 with _lastUpdated, for clients that cache the overview between sessions."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #optional
* suite.test[=].parameter.name = "since"
* suite.test[=].parameter.valueDateTime = "2026-01-01T00:00:00Z"
* suite.test[=].assertion.severity = #warning
* suite.test[=].assertion.human = "Every entry returned has meta.lastUpdated later than <since>."

* suite.test[+].name = "Retrieve the medication overview as a document"
* suite.test[=].description = "PHARM-12, Document Option: the client retrieves the Medication Overview Bundle document."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #document-option
* suite.test[=].assertion.severity = #error
* suite.test[=].assertion.expression.language = #text/fhirpath
* suite.test[=].assertion.expression.expression = "Bundle.type = 'document' and Bundle.entry.first().resource is Composition"
* suite.test[=].assertion.human = "The retrieved Bundle is a document whose first entry is a Composition conforming to the Medication Overview Composition profile."

* suite.test[+].name = "Reject a query that does not identify a patient"
* suite.test[=].description = "Negative test: an unscoped MedicationStatement search must not be issued by a conformant client, and must be refused by the Responder."
* suite.test[=].operation = #gherkin/scenario
* suite.test[=].mode = #required
* suite.test[=].assertion.severity = #error
* suite.test[=].assertion.expression.language = #text/fhirpath
* suite.test[=].assertion.expression.expression = "resourceType = 'OperationOutcome'"
* suite.test[=].assertion.human = "The response status is 400 or 403 and the body is an OperationOutcome."
