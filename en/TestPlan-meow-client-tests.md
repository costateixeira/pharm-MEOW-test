# MEOW Consumer (Client) Test Plan - IHE PHARM MEOW: TestPlan and Gherkin Demonstration v1.0.0

* [**Table of Contents**](toc.md)
* [**Artifacts Summary**](artifacts.md)
* **MEOW Consumer (Client) Test Plan**

## TestPlan: MEOW Consumer (Client) Test Plan (Experimental) 

| | |
| :--- | :--- |
| *Official URL*:http://example.com/fhir/ihe.pharm.meow.test/TestPlan/meow-client-tests | *Version*:1.0.0 |
| Draft as of 2026-08-26 | *Computable Name*:MEOWClientTestPlan |

 
Test plan for the **Medication Overview Consumer** actor (the **MEOW client**) defined by the [IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide. 
Each `suite.test` below corresponds to one `Scenario:` in the Gherkin feature file named by `suite.input.file`, matched by its `tc-meow-client-NNN` identifier. The system under test is the **client**: the SUT initiates every exchange, the test bed plays the Responder and judges what arrives. 

**Scopes**

* **Reference**: `https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewConsumer`
  * **Description**: The Medication Overview Consumer (MEOW client) actor - the system under test.

**1 Suite: IHE MEOW Medication Overview Consumer - client-side conformance**

Maps to the Feature of the same name in the Gherkin script. The test bed plays the Medication Overview Responder while the system under test drives every exchange.

**Inputs**

* **Name**: gherkin-script
  * **File**: meow-client-gherkin-script.feature

**Tests**

* **Name**: tc-meow-client-001 PHARM-11 query by patient and by optional parameters
  * **Description**: Three rounds, each a separate exchange triggered on the SUT, proving the Consumer can build each query rather than build one and repeat it: by patient alone, then patient + status, then patient + _lastUpdated.
  * **Operation**: gherkin/Scenario
* **Name**: tc-meow-client-002 Submitted overview conforms to MedicationOverview
  * **Description**: MEOW defines no submit transaction - both CapabilityStatements are read/search only - so the endpoint is deployment-specific and only the payload is governed by the profile.
  * **Operation**: gherkin/Scenario



## Resource Content

```json
{
  "resourceType" : "TestPlan",
  "resourceDefinition" : "http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-snapshot1",
  "id" : "meow-client-tests",
  "url" : "http://example.com/fhir/ihe.pharm.meow.test/TestPlan/meow-client-tests",
  "version" : "1.0.0",
  "name" : "MEOWClientTestPlan",
  "title" : "MEOW Consumer (Client) Test Plan",
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
  "description" : "Test plan for the **Medication Overview Consumer** actor (the *MEOW client*) defined by the\n[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html) implementation guide.\n\nEach `suite.test` below corresponds to one `Scenario:` in the Gherkin feature file named by\n`suite.input.file`, matched by its `tc-meow-client-NNN` identifier. The system under test is the\n**client**: the SUT initiates every exchange, the test bed plays the Responder and judges what arrives.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "http://unstats.un.org/unsd/methods/m49/m49.htm",
      "code" : "001",
      "display" : "World"
    }]
  }],
  "purpose" : "To declare, in a machine-readable and runnable form, which behaviours a system claiming conformance to the MEOW Medication Overview Consumer actor must demonstrate.",
  "scope" : [{
    "reference" : "https://profiles.ihe.net/PHARM/MEOW/CapabilityStatement/MedicationOverviewConsumer",
    "description" : "The Medication Overview Consumer (MEOW client) actor - the system under test."
  }],
  "runner" : "https://www.itb.ec.europa.eu/docs/guides/latest/",
  "suite" : [{
    "name" : "IHE MEOW Medication Overview Consumer - client-side conformance",
    "description" : "Maps to the Feature of the same name in the Gherkin script. The test bed plays the Medication Overview Responder while the system under test drives every exchange.",
    "input" : [{
      "name" : "gherkin-script",
      "file" : "meow-client-gherkin-script.feature"
    }],
    "test" : [{
      "name" : "tc-meow-client-001 PHARM-11 query by patient and by optional parameters",
      "description" : "Three rounds, each a separate exchange triggered on the SUT, proving the Consumer can build each query rather than build one and repeat it: by patient alone, then patient + status, then patient + _lastUpdated.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "Every PHARM-11 query the Consumer issues is a GET against /MedicationStatement carrying a patient parameter. A query without patient is non-conformant no matter what else it carries."
      },
      {
        "severity" : "error",
        "human" : "The Consumer asks for FHIR JSON, via the Accept header or the _format query parameter."
      },
      {
        "severity" : "error",
        "human" : "The optional search parameters the Consumer declares support for are built into the query itself - status and _lastUpdated narrow the search server-side, rather than the Consumer pulling everything and filtering locally."
      }]
    },
    {
      "name" : "tc-meow-client-002 Submitted overview conforms to MedicationOverview",
      "description" : "MEOW defines no submit transaction - both CapabilityStatements are read/search only - so the endpoint is deployment-specific and only the payload is governed by the profile.",
      "operation" : "gherkin/Scenario",
      "assertion" : [{
        "severity" : "error",
        "human" : "The overview the Consumer submits is a POST carrying FHIR JSON."
      },
      {
        "severity" : "error",
        "human" : "The submitted Bundle validates against the MEOW MedicationOverview profile."
      }]
    }]
  }]
}

```
