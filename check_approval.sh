      export RED='\033[0;31m'
      export NOCOLOR='\033[0m'
      export APPROVER_1="Sander van Vugt"
      export APPROVER_2="Kohsuke Kawaguchi"

      log() {
        echo -e "${RED}$1${NOCOLOR}"
      }

      log "I will try to verify information about who the approver is and whether the approver approved the merge request.\nThe approver must be ${APPROVER_1} or ${APPROVER_2}. If you have not added ${APPROVER_1} and ${APPROVER_2} as approvers, you need to close this merge request, open a new merge request or you need to edit the 'Assignee' section on the right side of the 'Merge requests' page immediately after you open merge request during the 2 minutes and add ${APPROVER_1} or ${APPROVER_2} as approvers."
      for i in {1..8}
      do
        APPROVAL_INFO=$(curl -s -X GET \
          --header "Private-Token: glpat-XXXXXXXXXXXXXXXXXX" \
          --url "http://GitLab_URL/api/v4/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/approvals")
        APPROVED=$(echo "${APPROVAL_INFO}" | jq -r '.approved')
        APPROVED_BY=$(echo "${APPROVAL_INFO}" | jq -r '.approved_by[].user.username')
        echo "APPROVED: ${APPROVED}"
        echo "APPROVED_BY: ${APPROVED_BY}"
        if [ "$APPROVED" = "true" ] && ( [ "$APPROVED_BY" = “$APPROVER_1” ] || [ "$APPROVED_BY" = “$APPROVER_2” ] ); then
          log "Your merge request is approved."
          echo "APPROVE=${APPROVED}" >> approval.env
          echo "APPROVER=${APPROVED_BY}" >> approval.env         
          cat approval.env
          exit 0
        else 
          log "Wait a moment, I'll try checking again."
          sleep 15  
        fi
        if [ "$i" -eq 8 ] && ( [ "$APPROVED_BY" != "$APPROVER_1" ] || [ "$APPROVED_BY" != "$APPROVER_2" ] ); then
          log "Sorry, your merge request cannot be merged.\nYou didn't assign an approver, or you assigned the wrong approver, or neither ${APPROVER_1} nor ${APPROVER_2} approved your merge request."
          echo "APPROVE=${APPROVED}" >> approval.env
          echo "APPROVER=${APPROVED_BY}" >> approval.env         
          cat approval.env
          exit 1
        fi  
      done