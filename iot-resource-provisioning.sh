#!/bin/bash
index=$1

if [ ! $index ]; then
  echo "Please input index value"
  exit 0
fi

mkdir ${index}

AWS_REGION="ap-northeast-1" # Overwrite for your region.

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Start to create policy."

policy_name="${index}_policy"
policy_file_name="${index}/${index}-policy.json"
sed -e "s/<<<INDEX>>>/${index}/g" ./policy_template.json > ${policy_file_name}

policy_arn=`aws iot create-policy \
  --policy-name ${policy_name} \
  --policy-document "file://${policy_file_name}" \
  --region ${AWS_REGION} \
  | jq -r '.policyArn'`

echo "Policy ARN: ${policy_arn}"

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Start to create Thing."

thing_name="${index}"

thing_arn=`aws iot create-thing \
  --thing-name ${thing_name} \
  --region ${AWS_REGION} \
  | jq -r '.thingArn'`

echo "Thing ARN: ${thing_arn}"

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Start to create certificate."

certificate_arn=`aws iot create-keys-and-certificate \
  --set-as-active \
  --certificate-pem-outfile "${index}/${index}-client-certificate.pem" \
  --public-key-outfile "${index}/${index}-public.key" \
  --private-key-outfile "${index}/${index}-private.key" \
  --region ${AWS_REGION} \
  | jq -r '.certificateArn'`

echo "Certificate ARN: ${certificate_arn}"

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Attach Policy to generated certificate."

aws iot attach-policy \
  --policy-name ${policy_name} \
  --target ${certificate_arn} \
  --region ${AWS_REGION}

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Attach IoT Thing to generated certificate."

aws iot attach-thing-principal \
  --thing-name ${thing_name} \
  --principal ${certificate_arn} \
  --region ${AWS_REGION}

echo "- - - - - - - - - - - - - - - - - - - -"
echo "Done."
