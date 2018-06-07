#!/bin/bash

ecrAcc=$1
ecrRepo=$2
ebApp=$3
ebEnv=$4

tmpLog="tmp.log"

mkdir eb && cd eb

# Create Dockerrun file
cat >> Dockerrun.aws.json << EOF
{
    "AWSEBDockerrunVersion": "1",
    "Image": {
        "Name": "${ecrAcc}/${ecrRepo}:latest",
        "Update": "true"
    },
    "Ports": [
    {
        "ContainerPort": "8080"
    }
    ]
}
EOF

mkdir .elasticbeanstalk
cat >> .elasticbeanstalk/config.yml << EOF
branch-defaults:
  default:
    environment: ${ebEnv}
    group_suffix: null
global:
  application_name: ${ebApp}
  default_ec2_keyname: buildMachine
  default_platform: Docker
  default_region: us-east-1
  profile: null
  sc: null

EOF

mv ../infr/.ebextensions/  .

~/.local/bin/eb deploy ${ebEnv} --timeout "60"

# Check Eb environment status
~/.local/bin/eb status | grep Status > "${tmpLog}"
grep -q "Ready" "$tmpLog"
if [ $? -ne 0 ]; then {
    echo "Eb Env has been updated with error"
    exit 1
} else {
    echo "Eb Env has been updated successfully"
}
fi
