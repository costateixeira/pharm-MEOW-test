// Companion to testplan-meow-client.fsh: same IHE PHARM MEOW profile, other
// side of the transaction. Here the system under test is the Medication
// Overview Responder (a server) and the test bed drives the exchange as the
// Consumer, so every assertion is on a response the test bed fetched itself.
//
// "resourceDefinition" is injected by _package.py - see the client plan.
Instance: meow-server-tests
InstanceOf: TestPlan
Usage: #definition
Title: "MEOW Responder (Server) Test Plan"
Description: "Test plan for the Medication Overview Responder actor (the MEOW server) of IHE PHARM MEOW."

* url = "http://example.com/fhir/ihe.pharm.meow.test/TestPlan/meow-server-tests"
* version = "1.0.0"
* name = "MEOWServerTestPlan"
* title = "MEOW Responder (Server) Test Plan"
* status = #draft
* experimental = true
* date = "2026-08-26"
* publisher = "Jose Costa Teixeira"
* contact
  * name = "Jose Costa Teixeira"
  * telecom
    * system = #url
    * value = "https://github.com/costateixeira/pharm-MEOW-test"

* description = """
Test plan for the **Medication Overview Responder** actor (the *MEOW server*) defined by the
[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide.

The suites below are split one per transaction - PHARM-11 Query Medication Resources and PHARM-12
Retrieve Medication Overview Document - matching the one-transaction-per-scenario structure of the
Gherkin script. Each `suite.test` corresponds to one `Scenario:` in that script, matched by its
`tc-meow-server-NNN` identifier.

The system under test is the **server**: the test bed originates every request and asserts on the
response it gets back.
"""
* purpose = "To declare, in a machine-readable and runnable form, which behaviours a system claiming conformance to the MEOW Medication Overview Responder actor must demonstrate."

// What is under test: the actor's CapabilityStatement.
* scope
  * reference = "https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewResponder"
  * description = "The Medication Overview Responder (MEOW server) actor - the system under test."

* runner = "https://www.itb.ec.europa.eu/docs/guides/latest/"

* mode[0]
  * code = "required"
  * description = "Tests every Medication Overview Responder must pass."
* mode[+]
  * code = "document-option"
  * description = "Tests that only apply to a Responder claiming the Document Option (PHARM-12)."

// ---------------------------------------------------------------------------
// PHARM-11 Query Medication Resources
// ---------------------------------------------------------------------------
* suite[0]
  * name = "PHARM-11 Query Medication Resources"
  * description = "Search on MedicationStatement, profiled as MedicationTreatmentLine. The patient parameter is required; status, effective, category and _lastUpdated are optional."
  * mode = #required

  // The pointer to the Gherkin.
  * input
    * name = "gherkin-script"
    * file = "meow-server-gherkin-script.feature"

  * test[0]
    * name = "tc-meow-server-001 PHARM-11 query by patient"
    * description = "The required baseline: a patient-scoped search returns that patient's treatment lines."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "The response is 200 and a Bundle of type searchset with at least one entry."
    * assertion[+]
      * severity = #error
      * human = "Every entry is a MedicationStatement whose subject resolves to the requested patient."
    * assertion[+]
      * severity = #error
      * human = "Every entry declares the MedicationTreatmentLine profile in meta.profile."

  * test[+]
    * name = "tc-meow-server-002 PHARM-11 honours the optional search parameters"
    * description = "status, category and _lastUpdated actually filter server-side rather than being ignored."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "A search filtered by status=active returns 200 and every entry carries that status."
    * assertion[+]
      * severity = #warning
      * human = "A search filtered by category returns 200 and a searchset."
    * assertion[+]
      * severity = #error
      * human = "A search with _lastUpdated set in the future returns 200 and an empty searchset - proof the parameter is applied rather than ignored."

  * test[+]
    * name = "tc-meow-server-003 PHARM-11 rejects a query without the required patient"
    * description = "Negative test: an unscoped MedicationStatement search must be refused, not answered."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "The response status is 400."
    * assertion[+]
      * severity = #error
      * human = "The body is an OperationOutcome carrying at least one issue of severity error or fatal."

// ---------------------------------------------------------------------------
// PHARM-12 Retrieve Medication Overview Document (Document Option)
// ---------------------------------------------------------------------------
* suite[+]
  * name = "PHARM-12 Retrieve Medication Overview Document"
  * description = "Document Option. Search for and read a Medication Overview document Bundle, then validate it against the MedicationOverview profile."
  * mode = #document-option

  * input
    * name = "gherkin-script"
    * file = "meow-server-gherkin-script.feature"

  * test[0]
    * name = "tc-meow-server-004 PHARM-12 returns a conformant MedicationOverview"
    * description = "A document search returns document Bundles, and a document read returns one that validates against the profile."
    * operation = #gherkin/Scenario
    * assertion[0]
      * severity = #error
      * human = "A search with patient and type=document returns 200 and a searchset whose entries are all Bundles of type document."
    * assertion[+]
      * severity = #error
      * human = "Reading a Medication Overview document returns 200 and a Bundle of type document."
    * assertion[+]
      * severity = #error
      * human = "The retrieved document validates against the MEOW MedicationOverview profile."
    * assertion[+]
      * severity = #error
      * human = "The document holds exactly one Composition, plus a Patient and at least one MedicationStatement."
