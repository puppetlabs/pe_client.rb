# Copilot Instructions

Purpose
- This repository is a Ruby gem. All code changes must maintain high quality and be fully covered by types (RBS) and tests (RSpec).

Project layout
- Ruby source code: `lib/`
- RBS signatures: `sig/`
- RSpec tests: `spec/`
- Minimum supported Ruby: 3.2

Quality gates (run all before opening a PR)
- StandardRB style: `bundle exec rake standard`
- YARD lint: `bundle exec rake yard_lint`
- RSpec tests: `bundle exec rake spec`
- All three MUST pass.

Rules for any new or changed code
- Every public class/module/method in `lib/` MUST have a matching RBS definition in `sig/`.
- Every behavior change MUST have RSpec coverage in `spec/` (happy path + edge cases).
- Prefer small, well-named, documented methods. Add YARD tags for all APIs.
- Follow StandardRB formatting; do not disable cops globally. Inline disables must be justified with comments.
- API endpoints MUST reflect the official Puppet documentation at https://help.puppet.com. When adding or modifying endpoints, verify paths, request/response schemas, and error handling against the docs. API index is located at https://help.puppet.com/pe/current/topics/api_index.htm

Typical workflow
1) Implement in `lib/`.
2) Add/update RBS in `sig/` to match public API and important internal types.
3) Add/update RSpec in `spec/`.
4) Cross-check any API endpoints with https://help.puppet.com (paths, parameters, response structure, error semantics).
5) Run quality gates:
   - `bundle exec rake standard`
   - `bundle exec rake yard_lint`
   - `bundle exec rake spec`
6) Iterate until all pass.

Testing guidance
- Use RSpec `describe` blocks mirroring file paths under `lib/`.
- Stub external I/O and network interactions; keep tests fast and deterministic.
- For API resources, include tests that validate request building, accepted parameters, and response parsing per https://help.puppet.com.

RBS guidance
- Mirror module/class namespaces and method signatures.
- Specify parameter types, return types, and raised errors for public methods.
- Keep signatures in sync with implementation on every change.

Documentation
- Add YARD docstrings for all APIs. Ensure `bundle exec rake yard_lint` passes.
- Prefer concise examples in method docs when behavior may be non-obvious.

Dependencies and compatibility
- Target Ruby 3.2+. Avoid features that break on 3.2.
- Prefer standard library and minimal dependencies.

CI expectations
- The CI will run the three quality gates. A PR is mergeable only if all pass.

Short checklist for each PR
- Code in `lib/`
- RBS in `sig/`
- RSpec in `spec/`
- StandardRB ok
- YARD lint ok
- RSpec green
- Ruby 3.2+ compatibility
- Endpoints match https://help.puppet.com
