# MEOW Responder (Server) Test Plan - IHE PHARM MEOW: TestPlan and Gherkin Demonstration v1.0.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **MEOW Responder (Server) Test Plan**

## TestPlan: MEOW Responder (Server) Test Plan (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:http://example.com/fhir/ihe.pharm.meow.test/TestPlan/meow-server-tests | *Version*:1.0.0 |
| Draft as of 2026-08-26 | *Computable Name*:MEOWServerTestPlan |

 
Test plan for the **Medication Overview Responder** actor (the **MEOW server**) defined by the [IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide. 
The suites below are split one per transaction - PHARM-11 Query Medication Resources and PHARM-12 Retrieve Medication Overview Document - matching the one-transaction-per-scenario structure of the Gherkin script. Each `suite.test` corresponds to one `Scenario:` in that script, matched by its `tc-meow-server-NNN` identifier. 
The system under test is the **server**: the test bed originates every request and asserts on the response it gets back. 

**Scopes**

* **Reference**: `https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewResponder`
  * **Description**: The Medication Overview Responder (MEOW server) actor - the system under test.

**Modes**

* **Code**: required
  * **Description**: Tests every Medication Overview Responder must pass.
* **Code**: document-option
  * **Description**: Tests that only apply to a Responder claiming the Document Option (PHARM-12).

**1 Suite: PHARM-11 Query Medication Resources**

Mode: required. Search on MedicationStatement, profiled as MedicationTreatmentLine. The patient parameter is required; status, effective, category and _lastUpdated are optional.

**Inputs**

* **Name**: gherkin-script
  * **File**: meow-server-gherkin-script.feature

**Tests**

* **Name**: tc-meow-server-001 PHARM-11 query by patient
  * **Description**: The required baseline: a patient-scoped search returns that patient's treatment lines.
  * **Operation**: gherkin/Scenario
* **Name**: tc-meow-server-002 PHARM-11 honours the optional search parameters
  * **Description**: status, category and _lastUpdated actually filter server-side rather than being ignored.
  * **Operation**: gherkin/Scenario
* **Name**: tc-meow-server-003 PHARM-11 rejects a query without the required patient
  * **Description**: Negative test: an unscoped MedicationStatement search must be refused, not answered.
  * **Operation**: gherkin/Scenario

-------

**2 Suite: PHARM-12 Retrieve Medication Overview Document**

Mode: document-option. Document Option. Search for and read a Medication Overview document Bundle, then validate it against the MedicationOverview profile.

**Inputs**

* **Name**: gherkin-script
  * **File**: meow-server-gherkin-script.feature

**Tests**

* **Name**: tc-meow-server-004 PHARM-12 returns a conformant MedicationOverview
  * **Description**: A document search returns document Bundles, and a document read returns one that validates against the profile.
  * **Operation**: gherkin/Scenario



## Resource Content

```json
{
  "resourceType" : "TestPlan",
  "resourceDefinition" : "http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1",
  "id" : "meow-server-tests",
  "url" : "http://example.com/fhir/ihe.pharm.meow.test/TestPlan/meow-server-tests",
  "version" : "1.0.0",
  "name" : "MEOWServerTestPlan",
  "title" : "MEOW Responder (Server) Test Plan",
  "status" : "draft",
  "experimental" : true,
  "date" : "2026-08-26",
  "publisher" : "Jose Costa Teixeira",
  "contact" : [{
    "name" : "Jose Costa Teixeira",
    "telecom" : [{
      "system" : "url",
      "value" : "https://github.com/costateixeira/pharm-MEOW-test"
    }]
  }],
  "description" : "Test plan for the **Medication Overview Responder** actor (the *MEOW server*) defined by the\n[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide.\n\nThe suites below are split one per transaction - PHARM-11 Query Medication Resources and PHARM-12\nRetrieve Medication Overview Document - matching the one-transaction-per-scenario structure of the\nGherkin script. Each `suite.test` corresponds to one `Scenario:` in that script, matched by its\n`tc-meow-server-NNN` identifier.\n\nThe system under test is the **server**: the test bed originates every request and asserts on the\nresponse it gets back.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "purpose" : "To declare, in a machine-readable and runnable form, which behaviours a system claiming conformance to the MEOW Medication Overview Responder actor must demonstrate.",
  "scope" : [{
    "reference" : "https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewResponder",
    "description" : "The Medication Overview Responder (MEOW server) actor - the system under test."
  }],
  "runner" : "https://www.itb.ec.europa.eu/docs/guides/latest/",
  "mode" : [{
    "code" : "required",
    "description" : "Tests every Medication Overview Responder must pass."
  },
  {
    "code" : "document-option",
    "description" : "Tests that only apply to a Responder claiming the Document Option (PHARM-12)."
  }],
  "suite" : [{
    "name" : "PHARM-11 Query Medication Resources",
    "description" : "Search on MedicationStatement, profiled as MedicationTreatmentLine. The patient parameter is required; status, effective, category and _lastUpdated are optional.",
    "mode" : "required",
    "input" : [{
      "name" : "gherkin-script",
      "file" : "meow-server-gherkin-script.feature"
    }],
    "test" : [{
      "name" : "tc-meow-server-001 PHARM-11 query by patient",
      "description" : "The required baseline: a patient-scoped search returns that patient's treatment lines.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "The response is 200 and a Bundle of type searchset with at least one entry."
      },
      {
        "severity" : "error",
        "human" : "Every entry is a MedicationStatement whose subject resolves to the requested patient."
      },
      {
        "severity" : "error",
        "human" : "Every entry declares the MedicationTreatmentLine profile in meta.profile."
      }]
    },
    {
      "name" : "tc-meow-server-002 PHARM-11 honours the optional search parameters",
      "description" : "status, category and _lastUpdated actually filter server-side rather than being ignored.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "A search filtered by status=active returns 200 and every entry carries that status."
      },
      {
        "severity" : "warning",
        "human" : "A search filtered by category returns 200 and a searchset."
      },
      {
        "severity" : "error",
        "human" : "A search with _lastUpdated set in the future returns 200 and an empty searchset - proof the parameter is applied rather than ignored."
      }]
    },
    {
      "name" : "tc-meow-server-003 PHARM-11 rejects a query without the required patient",
      "description" : "Negative test: an unscoped MedicationStatement search must be refused, not answered.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "The response status is 400."
      },
      {
        "severity" : "error",
        "human" : "The body is an OperationOutcome carrying at least one issue of severity error or fatal."
      }]
    }]
  },
  {
    "name" : "PHARM-12 Retrieve Medication Overview Document",
    "description" : "Document Option. Search for and read a Medication Overview document Bundle, then validate it against the MedicationOverview profile.",
    "mode" : "document-option",
    "input" : [{
      "name" : "gherkin-script",
      "file" : "meow-server-gherkin-script.feature"
    }],
    "test" : [{
      "name" : "tc-meow-server-004 PHARM-12 returns a conformant MedicationOverview",
      "description" : "A document search returns document Bundles, and a document read returns one that validates against the profile.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "A search with patient and type=document returns 200 and a searchset whose entries are all Bundles of type document."
      },
      {
        "severity" : "error",
        "human" : "Reading a Medication Overview document returns 200 and a Bundle of type document."
      },
      {
        "severity" : "error",
        "human" : "The retrieved document validates against the MEOW MedicationOverview profile."
      },
      {
        "severity" : "error",
        "human" : "The document holds exactly one Composition, plus a Patient and at least one MedicationStatement."
      }]
    }]
  }]
}

```
