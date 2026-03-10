---
name: helm-unittest
description: Guides using helm-unittest for Helm charts. Use when writing unit tests for Helm templates or implementing new complex features in a chart.
---

# Running tests
- To run tests, simply run `helm unittest <chart-path>`

# Creating Tests
- When creating tests, name them using the BDD-like `given ... then ...` format
  - Givens describe the chart's values or release information
  - Thens describe the tests' asserts
  - If you can't infer the business rules, prefer to stop and prompt the user for the rules and instruct to provide them in this format
- Test only business rules
  - It's easy to over-test Helm Charts, avoid it
  - Do not test "setters" or "basic enables": "given I set value foo to bar then foo is configured to bar" is a bad test
  - Test complex logic: "given no configured match patterns then should default to a catch-all" is a good test
- Individual test files should test individual templates
  - All tests should be associated with a template file that (optionally) actually renders a document
  - The exception is when testing integration between multiple templates, this should go into its own file
  - Name suites in a human readable format that references which templates are being tested: `httproute tests`, `deployment and configmap tests`
- Setting values for the tests:
  - In the root `set`, `release` and similar configs, you can configure basic values to enable all tests, for example: `ingress.enabled=true` for ingress tests
  - All tests should configure values referred to in the "givens" part of the test name, even if already specified at the root
- Minimize the number of asserts per test, prefer more precise asserts over generic ones like `hasDocument`, but only validate the tests requirements, nothing more

# Test Schema
- If necessary, load the [unittest JSON Schema](./helm-testsuite.json)

# Other
- If you need more information, read [Helm Unittest's README](https://raw.githubusercontent.com/helm-unittest/helm-unittest/refs/heads/main/README.md)
  - Be careful! It is large and distracting, avoid if possible, do only if necessary

# Troubleshooting
- If the command errors with the plugin not being installed, install it: `helm plugin install https://github.com/helm-unittest/helm-unittest.git`
  - If the user does not want to install the plugin, you can try running using the container image `helmunittest/helm-unittest`
