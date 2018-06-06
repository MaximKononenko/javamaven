#!/bin/bash

ebApp=$1
ebEnv=$2

mkdir eb && cd eb

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

mkdir .elasticbeanstalk/saved_configs
mv ../infr/saved_configs/sample-config.cfg.yml .elasticbeanstalk/saved_configs/${ebEnv}-config.cfg.yml
~/.local/bin/eb config put ${ebEnv}-config.cfg.yml
~/.local/bin/eb config ${ebEnv} --cfg ${ebEnv}-config --timeout 60

# Check Eb environment status
###cd ${scriptsDir}/eb/${env} && /usr/local/bin/eb status | grep Status > "${tmpLog}"
###grep -q "Ready" "${tmpLog}"
###if [ $? -ne 0 ]; then {
###	exit 1
###}
###fi
