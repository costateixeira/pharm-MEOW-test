// TestPlan/TestScript/TestReport were in R6 core up to 6.0.0-ballot3, but were
// taken out again for ballot5 - they now live only in hl7.fhir.uv.testing, which
// holds "the latest definitions of the R6 resources until they are considered
// stable". So this IG depends on that package and uses its TestPlan shape
// (scope / runner / mode / suite), not the older testCase shape.
//
// The Gherkin is pointed at from suite.input.file.
Instance: meow-client-tests
InstanceOf: TestPlan
Usage: #definition
Title: "MEOW Consumer (Client) Test Plan"
Description: "Test plan for the Medication Overview Consumer actor (the MEOW client) of IHE PHARM MEOW."

* url = "http://example.com/fhir/example/TestPlan/meow-client-tests"
* version = "1.0.0"
* name = "MEOWClientTestPlan"
* title = "MEOW Consumer (Client) Test Plan"
* status = #draft
* experimental = true
* date = "2026-08-26"
* publisher = "My Organization"
* contact
  * name = "Bob Smith"
  * telecom
    * system = #email
    * value = "bobsmith@example.com"
    * use = #work

* description = """
Test plan for the **Medication Overview Consumer** actor (the *MEOW client*) defined by the
[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide.

Each `suite.test` below corresponds to one `Scenario:` in the Gherkin feature file named by
`suite.input.file`, matched by its `tc-meow-client-NNN` identifier. The system under test is the
**client**: the SUT initiates every exchange, the test bed plays the Responder and judges what arrives.
"""
* purpose = "To declare, in a machine-readable and runnable form, which behaviours a system claiming conformance to the MEOW Medication Overview Consumer actor must demonstrate."

// What is under test: the actor's CapabilityStatement.
* scope
  * reference = "https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewConsumer"
  * description = "The Medication Overview Consumer (MEOW client) actor - the system under test."

* runner = "https://www.itb.ec.europa.eu/docs/guides/latest/"

* suite
  * name = "IHE MEOW Medication Overview Consumer - client-side conformance"
  * description = "Maps to the Feature of the same name in the Gherkin script below. The test bed plays the Medication Overview Responder while the system under test drives every exchange."

  // The pointer to the Gherkin.
  * input
    * name = "gherkin-script"
    * file = "meow-client-gherkin-script.feature"

  * test[0]
    * name = "tc-meow-client-001 PHARM-11 query by patient and by optional parameters"
    * description = "Three rounds, each a separate exchange triggered on the SUT, proving the Consumer can build each query rather than build one and repeat it: by patient alone, then patient + status, then patient + _lastUpdated."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "Every PHARM-11 query the Consumer issues is a GET against /MedicationStatement carrying a patient parameter. A query without patient is non-conformant no matter what else it carries."
    * assertion[+]
      * severity = #error
      * human = "The Consumer asks for FHIR JSON, via the Accept header or the _format query parameter."
    * assertion[+]
      * severity = #error
      * human = "The optional search parameters the Consumer declares support for are built into the query itself - status and _lastUpdated narrow the search server-side, rather than the Consumer pulling everything and filtering locally."

  * test[+]
    * name = "tc-meow-client-002 Submitted overview conforms to MedicationOverview"
    * description = "MEOW defines no submit transaction - both CapabilityStatements are read/search only - so the endpoint is deployment-specific and only the payload is governed by the profile."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "The overview the Consumer submits is a POST carrying FHIR JSON."
    * assertion[+]
      * severity = #error
      * human = "The submitted Bundle validates against the MEOW MedicationOverview profile."
