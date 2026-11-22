# Member A — Week 2 & Week 3 Work Package

## A's role
According to the group's work plan, A owns paper claims and research analysis: make paper claims testable, map claims to group evidence, compare paper setup with ours, and produce evidence-based preliminary verdicts.

## Week 2
- `docs/claims_and_metrics.md`: define 1–3 claims, operational questions, metrics, and evidence requirements.
- `docs/paper_results.md`: preserve the paper's original setup and headline figures (already present in the repository according to the prior file inventory).
- Agree with the group on reproduction scope and explicitly state that PolyBench/C is not SPEC CPU2006.

## Week 3
- `docs/claim_verification.md`: preliminary verdict per claim and evidence gaps.
- `docs/paper_ours_notes.md`: Paper-vs-Ours comparison and deviations.
- Follow up with B, C, D / actual machine operators for missing evidence.

## Audit blockers
- CSV environment mapping was reported as `first_i9_second_i7_extended_i9`; the meaning of first/second/extended and row-level provenance still needs confirmation.
- Coverage of all three workloads on both machines is unknown.
- Memory measurement method is unknown. The CSV header says RSS (KB), but this does not prove the collection method.
- Compiler versions and paired compile flags need confirmation.
- `analysis.py` assumes three runs and computes sample standard deviation. Verify valid values and Normal/ASan pairs for every workload.

## Immediate actions
1. Ask D (i9 operator) to identify exact source and setup for i9 runs.
2. Ask the i7 operator to identify exact source and setup for i7 runs.
3. Ask B how CSV files were assembled and which script generated them.
4. Ask the data collector for exact timing and memory commands.
5. Preserve old CSVs; save reruns as a separate dated batch with logs and metadata.

## GitHub commit
Suggested message: `[Student ID] Full Name: Add claim mapping and preliminary verification`

Replace with A's own student ID and full name. The course requires each member's own meaningful weekly commit from their own account.
