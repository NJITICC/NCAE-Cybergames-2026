# Issue Title

Provide a concise, descriptive title for the issue.  
Example: Apache Port 80 Connection Refused on Ubuntu

---

## Error Message

Paste the exact error message(s) observed.  
Do not paraphrase.

```text
PASTE ERROR OUTPUT HERE
```

If multiple errors exist, include all relevant output.

---

## Description

Describe the issue in clear terms:
- What failed?
- When did it occur?
- What service or functionality was impacted?
- Was this observed during setup, hardening, or live operation?

Avoid describing the fix here, focus on understanding the failure.

---

## Environment

Specify the affected environment.

- Operating System:
- Service / Application:
- Configuration File(s) Involved:
- Network Context (if applicable):

---

## Resolution Procedure

Document the exact steps taken to resolve the issue.

Guidelines:
- Use numbered steps
- Include commands as needed
- Reference configuration files explicitly
- Do not assume prior knowledge

Example:
1. Verified service status using systemctl
2. Identified blocked port in firewall rules
3. Opened port 80 using firewall-cmd
4. Restarted Apache service

---

## Validation

Explain how the fix was verified.

Examples:
- Service status confirmed running
- Port reachable via browser or curl
- Scoring service restored
- No new errors in logs

---

## Related Roles

List roles that would benefit from understanding this issue.

Examples:
- Web Administrator
- Network Administrator
- Incident Responder

---

## Scoring Impact (If Applicable)

Describe how this issue affected scoring.

- Direct service impact:
- Indirect service impact:
- Estimated point loss or risk:

If unknown, state Unknown.

---

## Lessons Learned

(Optional but encouraged)

- What caused the issue?
- How could it be prevented?
- Was there an earlier indicator?

---

## Founder / Author

Record who encountered and documented this issue.

Name:
Role:
Date:

---

## Related Issues (Optional)

Link any similar or related issues.

Example:
- ../Apache_SSL_Certificate_Expired/

