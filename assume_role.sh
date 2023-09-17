#!/bin/bash

SERIAL_NUMBER='arn:aws:iam::158111981908:mfa/ssingh'
SOURCE_PROFILE='default'
DATE=`date +%s`

PROFILE=$(aws configure list-profiles  | fzf)

# Bold High Intensity
NC='\033[0m' # No Color
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
On_IRed='\033[0;101m'     # Red background
BIWhite='\033[1;97m'      # White
IRed_BIWhite='\033[1;31;101m'

if [ "$PROFILE" = "" ]; then
    return 1
fi

echo "Input MFA Code: "
read -s TOKEN_CODE

REGION=$(aws configure get region --profile $PROFILE)
ROLE_ARN=$(aws configure get role_arn --profile $PROFILE)

if [[ "$PROFILE" == "default" ]] || [[ "$ROLE_ARN" == "" ]]; then
    unset AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_SESSION_TOKEN
    echo -e "\nSetting up the MFA for profile: ${BIRed}${PROFILE}${NC} in ${BIYellow}${REGION}${NC}"
    RESPONSE=$(aws sts get-session-token \
        --serial-number ${SERIAL_NUMBER} \
        --token-code    ${TOKEN_CODE} \
        --region        ${REGION} \
        --profile       ${PROFILE}
    )
    export AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $OUTPUT | jq -r .Credentials.SessionToken)
else
    unset AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_SESSION_TOKEN
    echo -e "\nSetting up the MFA for profile ${BIRed}${PROFILE}${NC} using IAM role ${BIGreen}${ROLE_ARN}${NC} in ${BIYellow}${REGION}${NC}"
    OUTPUT=$(aws sts assume-role \
        --role-arn          ${ROLE_ARN} \
        --serial-number     ${SERIAL_NUMBER} \
        --role-session-name ${DATE}-session \
        --profile           ${SOURCE_PROFILE} \
        --region            ${REGION} \
        --token-code        ${TOKEN_CODE}

    )
    export AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $OUTPUT | jq -r .Credentials.SessionToken)
    echo ""
# else
#     echo -e "\n${IRed_BIWhite}Assume role failed. No ROLE_ARN is defined for profile: ${NC}${BIYellow}${PROFILE}${NC}"
fi

aws sts get-caller-identity | jq
