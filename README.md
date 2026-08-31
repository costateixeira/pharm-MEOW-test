IHE PHARM MEOW — TestPlan and Gherkin Demonstration
---

A demonstration IG showing how the `TestPlan` resource and Gherkin feature files can
declare the conformance tests for the actors of
[IHE PHARM Medication Overview (MEOW)](https://profiles.ihe.net/PHARM/MEOW/index.html).

**This is not an approved IHE test specification.** It exists to exercise the tooling.

### What is in here

| Path | |
| --- | --- |
| `input/fsh/testplan-meow-client.fsh` | TestPlan for the Medication Overview Consumer |
| `input/fsh/testplan-meow-server.fsh` | TestPlan for the Medication Overview Responder |
| `input/testing/gherkin/*.feature` | The Gherkin scripts the plans point at, written for the [Interoperability Test Bed](https://www.itb.ec.europa.eu/docs/guides/latest/) |
| `input/fsh/binary-gherkin.fsh` | Binaries that render the scripts on the IG site (presentational only) |
| `_package.py` | Builds `dist/package.tgz` from SUSHI output without the IG Publisher |
| `ISSUE-ig-publisher-additional-resources.md` | Write-up of the publisher behaviour this IG ran into |

`TestPlan` is not in core: it was in R6 through `6.0.0-ballot3` but removed for
`6.0.0-ballot5`, which this guide targets, so it comes from `hl7.fhir.uv.testing`.

### Building

```
_build.bat            # or _genonce.bat / _genonce.sh
python _package.py    # sushi + package only, no publisher -> dist/package.tgz
```

### Publication

Continuous Build: __https://build.fhir.org/ig/costateixeira/pharm-MEOW-test/branches/master/index.html__

### Issues

Issues:  __https://github.com/costateixeira/pharm-MEOW-test/issues__

---
