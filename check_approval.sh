#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
NOCOLOR="\033[0m"
APPROVER_1_FULL_NAME="Vüsal Kərimov"
APPROVER_2_FULL_NAME="Emin Rəhmanov"
APPROVER_1_DOMAIN_NAME="v.karimov"
APPROVER_2_DOMAIN_NAME="e.rahmanov"

log_info() {
  echo -e "${GREEN}${1}${NOCOLOR}"
}

log_error() {
  echo -e "${RED}${1}${NOCOLOR}"
}

log_info "I will try to verify information about who the approver is and whether the approver approved the merge request.\nThe approver must be '${APPROVER_1_FULL_NAME}' or '${APPROVER_2_FULL_NAME}'. If you have not added '${APPROVER_1_FULL_NAME}' and '${APPROVER_2_FULL_NAME}' as approvers, you need to close this merge request, open a new merge request or you need to edit the 'Assignee' section on the right side of the 'Merge requests' page immediately after you open merge request during the 2 minutes and add '${APPROVER_1_FULL_NAME}' or '${APPROVER_2_FULL_NAME}' as approvers."
for i in {1..8}
do
  APPROVAL_INFO=$(curl -s -X GET \
    --header "Private-Token: $MERGE_APPROVE_TOKEN" \
    --url "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/approvals")
  APPROVED=$(curl -s -X GET \
    --header "Private-Token: $MERGE_APPROVE_TOKEN" \
    --url "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/approvals" | jq -r '.approved')
  APPROVED_BY=$(curl -s -X GET \
    --header "Private-Token: $MERGE_APPROVE_TOKEN" \
    --url "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/approvals" | jq -r '.approved_by[].user.username')
  echo "APPROVED: ${APPROVED}"
  echo "APPROVED_BY: ${APPROVED_BY}"
  if [ "$APPROVED" = "true" ] && ( [ "$APPROVED_BY" = "$APPROVER_1_DOMAIN_NAME" ] || [ "$APPROVED_BY" = "$APPROVER_2_DOMAIN_NAME" ] ); then
    log_info "Your merge request is approved."
    echo "APPROVE=${APPROVED}" >> approval.env
    echo "APPROVER=${APPROVED_BY}" >> approval.env         
    cat approval.env
    exit 0
  else 
    log_info "Wait a moment, I'll try checking again."
    sleep 15  
  fi
  if [ "$i" -eq 8 ] && ( [ "$APPROVED_BY" != "$APPROVER_1_DOMAIN_NAME" ] || [ "$APPROVED_BY" != "$APPROVER_2_DOMAIN_NAME" ] ); then
    log_error "Sorry, your merge request cannot be merged.\nYou didn't assign an approver, or you assigned the wrong approver, or neither '${APPROVER_1_FULL_NAME}' nor '${APPROVER_2_FULL_NAME}' approved your merge request."
    echo "APPROVE=${APPROVED}" >> approval.env
    echo "APPROVER=${APPROVED_BY}" >> approval.env         
    cat approval.env
    exit 1
  fi  
done
