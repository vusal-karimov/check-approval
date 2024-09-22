**Merge Request Approval Script**

If you use GitLab Free, this script for you. 

![IMAGE_DESCRIPTION](./you.jpg)

**Overview**

Approvals in GitLab Free are optional, and don’t prevent a merge request from merging without approval. This script is designed to automate the verification process of merge request approvals in GitLab Free. It checks whether a merge request has been approved by one of the designated approvers. If the approval conditions are not met within a specified timeframe, the script will instruct the user to either close the merge request or update the assignees.

**Script Details**

**Approvers**

Approver 1: "Sander van Vugt"
Approver 2: "Kohsuke Kawaguchi"

**Functionality**

The script performs the following tasks:

Sets up color coding for log messages.
Defines the approvers.
Logs an initial message explaining the approval requirements.
Checks the approval status of the merge request in a loop (up to 8 times, with a 15-second interval between checks).
If the merge request is approved by one of the designated approvers, it logs a success message and saves the approval information.
If the conditions are not met after 8 checks, it logs an error message and exits with a failure status.

**Script Explanation**

**Environment Variables**

RED: ANSI escape code for red text.
NOCOLOR: ANSI escape code to reset text color.
APPROVER_1: The first designated approver.
APPROVER_2: The second designated approver.

**Log Function**

A simple logging function to print messages in red color.

**Approval Check Loop**

The script uses a loop to check the approval status from the GitLab API. It sends a GET request to the GitLab API endpoint for merge request approvals, parses the JSON response, and checks if the merge request has been approved by either of the designated approvers.

**Exit Conditions**

Success: If the merge request is approved by one of the approvers, the script logs a success message, writes the approval information to "approval.env", and exits with a status of 0.
Failure: If the merge request is not approved by the designated approvers after 8 checks, the script logs an error message, writes the failure information to "approval.env", and exits with a status of 1.

**Important Notes**

GitLab API Token: Ensure you replace "glpat-XXXXXXXXXXXXXXXXXX" with a valid GitLab private token.
GitLab URL: Update "http://GitLab_URL" with the correct URL of your GitLab instance.
Environment Variables: "CI_PROJECT_ID" and "CI_MERGE_REQUEST_IID" are GitLab's predefined CI/CD variables, and by combining these variables, you get the current project ID and project-level IID (internal ID) of the merge request for this project ID.
