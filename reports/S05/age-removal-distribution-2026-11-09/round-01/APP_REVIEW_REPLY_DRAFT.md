# Unsent reviewer reply — do not send from this task

Status: DRAFT / NOT_SENT. Use only after independent distribution audit, verified build selection and owner-authorized metadata reconciliation. Processing/signature results are in DELIVERY.md and original evidence; no statement here constitutes a submitted review response.

---

Hello App Review,

We have prepared a replacement, Lecture Asset 0.1.0 (36.1), for the previously reviewed 35.1 build.

For Guideline 5.1.1(iv), the Photos permission pre-prompt uses the neutral button “Continue” (“继续” in Simplified Chinese). Selecting it presents Apple's native Photos permission request. Tutorial, About and privacy information remain readable without granting Photos access. The complete photo organization/cleanup workflow requires full read-write Photos authorization.

For the age-related review questions and your November 8 request, the previously reviewed 35.1 contained a conditional age-assurance feature. The replacement removes the entire feature, rather than hiding its UI: no Declared Age Range service, no age request, no App age entitlement and no age-related feature gating remain. It does not request date of birth or maintain age records. There is therefore no age-assurance flow to demonstrate in this replacement. We acknowledge that your prior request concerned the old binary; we are explaining the changed binary, not assuming the request has been waived.

Reproduction for the replacement: launch the app; complete or dismiss the optional tutorial if shown; the normal Photos permission or authorized photo-selection screen appears without an age request. With Photos access not yet granted, tap Continue/继续 to view the native Photos permission dialog. If Photos access was previously granted, the library or retained task opens directly. No account or login is required.

All processing remains local, and the archive/share/recovery and exact-source deletion safeguards remain intact. Source deletion still requires an integrity-checked ZIP, completed ZIP sharing, separate external-save confirmation, a fresh delete action and the system Photos confirmation. No photos are automatically deleted at launch.

Please let us know if you need an ordinary-function demo of this replacement on a physical device.

---

## Required pre-send checks (not executed)

- Owner selects the genuinely processed **36.1** in the review version. The task deliberately leaves **35.1** selected.
- Latest readback reports Age Assurance **No**, compared with Yes before the run; this was not changed by R5. Owner confirmed the Yes → No change and stopping the old review submission. Retain Parental Controls No and the correctly recalculated rating; reconcile why zh-Hans is absent before review. Do not silently restore metadata or treat intent to resubmit later as authorization to submit now.
- Resolve/escalate the outstanding US/Texas release risk before resubmitting; do not claim Apple approval, 4+ or another utility's release proves a legal exception.
- Physical-device observation is recorded separately. This draft does not claim a new 36.1 physical video or a waived Apple request.
- Preserve AFTER_APPROVAL intentionally: approval can cause immediate publication. No resubmission or public release is authorized by R5.
