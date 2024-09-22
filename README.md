**Merge Request Approver Verification Script**

If you use GitLab Free, this script for you. 

![IMAGE_DESCRIPTION](./you.jpg)

Approvals in GitLab Free are optional, and don’t prevent a merge request from merging without approval. This script is designed to automate the verification process of merge request approvals in GitLab Free. It checks whether a merge request has been approved by one of the designated approvers. If neither of the required approvers has approved the request within a set timeframe, the script will fail the merge.

**Key Features:**

•	Approver Verification: Ensures that the approvers are either Vüsal Kərimov (v.karimov) or Emin Rəhmanov (e.rahmanov).

•	Automated Retry Mechanism: Checks the approval status every 15 seconds, up to 8 times, before determining success or failure.

•	Approval Status Output: Logs the approval status and approver details into approval.env for further processing.

•	Customizable: Modify the approvers or adjust the retry logic as needed for your use case.

**Requirements:**

•	GitLab Personal Access Token: You must supply a valid personal access token ($MERGE_APPROVE_TOKEN) with sufficient permissions to access the project's merge request approvals API.

•	GitLab API URL and Merge Request Data: The script uses the $CI_API_V4_URL, $CI_PROJECT_ID, and $CI_MERGE_REQUEST_IID environment variables to interact with the GitLab API.

**Usage:**

Add the required approvers immediately after opening a merge request, and this script will verify the approval status. If the required approvers are not assigned or have not approved within the specified time, the merge request will be rejected.
