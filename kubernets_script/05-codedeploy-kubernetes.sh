#!/usr/bin/env sh
# Verify what is present in aws-auth configmap before change

kubectl get configmap aws-auth -o yaml -n kube-system

# Export your Account ID
export ACCOUNT_ID="XXXXX"  #AWS Account ID
ROLEARN="ROLE_ARN of Codebuild role"  #Role Arn. Role is created out of the cloudformation script executed before it. You can check the Cloudformation Output (Console) for the Arn.

# Set ROLE value
ROLE="    - rolearn: $ROLEARN\n      username: build\n      groups:\n        - system:masters"

# Get current aws-auth configMap data and attach new role info to it
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml

# Patch the aws-auth configmap with new role
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"

# Verify what is updated in aws-auth configmap after change
kubectl get configmap aws-auth -o yaml -n kube-system
