# Quick note on how to deploy the image factory on CSP using ansible playbooks.

- USE THIS TOOL AT YOUR OWN RISKS!

- Create a csp.<csp>.vars.yml file according to your environment.

Currently only AWS is handled. Start with the default file provided.

$ cp csp.aws.vars.yml-default csp.aws.vars.yml

Pay particular attention to the following variables. 

key_name: the_key               => replace with your key
imgfactory_env:
  eu-west-1:
    ami_id: ami-7abd0209        => choose centos AMI
    ami_rdn: /dev/sda1          => set to the root_device_name of the chosen AMI
    vpc_id: vpc-xxxxxxxx        => replace with your VPC ID
    subnet_id: subnet-xxxxxxxx  => replace with your Subnet ID

- Define AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables

export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx

- Deploy on the chosen CSP

$ ./csp.sh --provider aws --action deploy

- Undeploy from the chosen CSP

Work in progress, need to remove instance manually...

$ ./csp.sh --provider aws --action undeploy


