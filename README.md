# demoapp

Pls find demo (17min) of executing here: https://youtu.be/uPRqRJxorL4

Github ref: https://github.com/MaximKononenko/javamaven

AWS: https://killbarby.signin.aws.amazon.com/console (demoapp/demoapp)

# This scripts are developed to deploy environment on AWS using EC2, EBS, ECR, CW and IAM services.
 
 ./app - folder with app files
 ./develop - not ready scripts. Not ready part of overall task like compose docker container with wordpress, CI scripts, smoke tests. 
 ./infr - folder with scripts and configs
 ./infr/.ebextentions - default EC2 instance configuration and  cloudwatch template. Using for updateEb.sh script.
 ./infr/saved_configs - contains EBS config that can be used to change environment parameters and apply by using updateEb.sh.


1. Create environment

createEB.sh $ebApp $ebEnv

This scrips is deploying nginx EC2 instance using nginx:latest docker template. It is creating EBS environment with default configuration and setting IAM roles.

2. Deployment
Folowing scripts should be run in this sequence:

pack.sh <params>
deploy.sh <params>

2.1. pack.sh $ecrAcc $ecrRepo

This script is building conteiner with latest code (./app/index.html) on build server and pushing to AWS ECR using AWS CLI.

2.2. deploy.sh $ecrAcc $ecrRepo $ebApp $ebEnv

Deploying to EC2 instance via "eb deploy" EBS CLI from latest container on ECR.

3. Update environment

upadteEb.sh $ebApp $ebEnv

You can change env configuration during application deploy just adding this script to CI pipeline like

updateEb.sh <params>
pack.sh <params>
deploy.sh <params>

This script just swithing env configs using EBS CLI "eb config".

