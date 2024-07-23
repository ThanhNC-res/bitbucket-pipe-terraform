FROM amazonlinux:latest
RUN yum update -y \ 
    && yum install unzip jq wget git -y \ 
    && yum install -y yum-utils \ 
    && yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo \ 
    && yum -y install terraform \ 
    && yum install -y aws-cli \ 
    && aws --version

COPY pipe /
COPY pipe.yml /

RUN wget --no-verbose -P / https://bitbucket.org/bitbucketpipelines/bitbucket-pipes-toolkit-bash/raw/0.6.0/common.sh

RUN chmod a+x /*.sh

ENTRYPOINT ["/pipe.sh"]