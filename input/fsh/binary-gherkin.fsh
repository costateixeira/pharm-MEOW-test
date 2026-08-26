// ===== RENDERING ONLY - delete this file with the Binary resource entry =====
// The Gherkin ships to runners as a raw .feature under package/tests/ via the
// path-test parameter. This Binary exists only so the script also renders as a
// syntax-highlighted artifact page on the IG website.
Instance: meow-client-gherkin-script
InstanceOf: Binary
Usage: #definition
* language = #en
* contentType = #text/x-gherkin
// "ig-loader-<filename>" makes the publisher inline the contents of the named
// file at build time, so the Gherkin never has to be pasted in as base64.
* data = "ig-loader-meow-client-gherkin-script.feature"
