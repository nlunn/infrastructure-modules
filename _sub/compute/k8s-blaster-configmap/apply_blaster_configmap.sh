# Exit if any of the intermediate steps fail
set -e


# Define varibales
APPLY_CONFIGMAP=0
KUBE_CONFIG_PATH=$1
CONFIGMAP_PATH_S3=$2


# Generate AWS CLI config files, if 
if [ -n "$3" ]; then
    AWS_ASSUME_ARN=$3
    AWS_ASSUMED_CREDS=( $(aws sts assume-role \
        --role-arn "$AWS_ASSUME_ARN" \
        --role-session-name "ApplyBlasterConfigmap" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text
    ) )
    AWS_ASSUMED_ACCESS_KEY_ID=${AWS_ASSUMED_CREDS[0]}
    AWS_ASSUMED_SECRET_ACCESS_KEY=${AWS_ASSUMED_CREDS[1]}
    AWS_ASSUMED_SESSION_TOKEN=${AWS_ASSUMED_CREDS[2]}    
fi


# Determine if key file exists in S3
if [ -n "$AWS_ASSUME_ARN" ]; then
    AWS_ACCESS_KEY_ID=${AWS_ASSUMED_ACCESS_KEY_ID} \
    AWS_SECRET_ACCESS_KEY=${AWS_ASSUMED_SECRET_ACCESS_KEY} \
    AWS_SESSION_TOKEN=${AWS_ASSUMED_SESSION_TOKEN} \
    aws s3 ls $CONFIGMAP_PATH_S3 >/dev/null && APPLY_CONFIGMAP=1
else
    aws s3 ls $CONFIGMAP_PATH_S3 >/dev/null && APPLY_CONFIGMAP=1
fi


# Create new key
if [ $APPLY_CONFIGMAP -eq 1 ]; then

    echo "Applying configmap from $CONFIGMAP_PATH_S3"

    if [ -n "$AWS_ASSUME_ARN" ]; then
        AWS_ACCESS_KEY_ID=${AWS_ASSUMED_ACCESS_KEY_ID} \
        AWS_SECRET_ACCESS_KEY=${AWS_ASSUMED_SECRET_ACCESS_KEY} \
        AWS_SESSION_TOKEN=${AWS_ASSUMED_SESSION_TOKEN} \
        aws s3 cp $CONFIGMAP_PATH_S3 - | kubectl -f -
    else
        aws s3 cp $CONFIGMAP_PATH_S3 - | kubectl -f -
    fi

else

    echo "No configmap found at $CONFIGMAP_PATH_S3 or permission denied"

fi