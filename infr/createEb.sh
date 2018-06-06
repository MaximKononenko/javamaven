#!/bin/bash

ebApp=$1
ebEnv=$2

mkdir eb && cd eb

# Create Dockerrun file
cat >> Dockerrun.aws.json << EOF
{
    "AWSEBDockerrunVersion": "1",
    "Image": {
        "Name": "nginx:latest",
        "Update": "true"
    },
    "Ports": [
    {
        "ContainerPort": "80"
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
  default_ec2_keyname: us-east-1
  default_platform: Docker
  default_region: us-east-1
  profile: null
  sc: null

EOF

mv ../infr/.ebextensions/ .

~/.local/bin/eb create $ebEnv --cname $ebEnv --timeout 60
