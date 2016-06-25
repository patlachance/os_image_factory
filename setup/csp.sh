#!/bin/sh

function usage {
  cat <<EOT

usage : $0 {--debug} --provider <provider> --action <action> 

where
    debug         run in debug mode
    provider      {aws}
    action        {deploy,undeploy}
}

EOT
  exit 1
}

error() {
  echo "ERROR: $1"
  echo "LEAVING..."
  exit 2
}

# Checking build options
if [ $# -eq 0 ]
then
   usage
fi


OPTS=$(getopt -o h -l debug,action:,provider: -- "$@" )
if [ $? != 0 ]
then
    usage "Invalid options"
fi
eval set -- "$OPTS"

DEBUG=""

while true ; do
    case "$1" in
        -h) 
            usage;;
        --debug)
            # set -x
            DEBUG="-vvvv"
            shift;;
        --action) 
            ACTION="$(echo "$2" | awk '{ print $1}')"
            case "$ACTION" in
                deploy|undeploy)
                    # Nothing to do
                    ;;
                *)
                    error "action '$ACTION' not supported!"
                    ;;
            esac
            shift;shift;; 
        --provider) 
            CSP="$(echo "$2" | awk '{ print $1}')"
            # Checking credentials
            CREDFILE="$HOME/.my_secrets/${CSP}.rc"
            # Checking if credentials file exists
            if [ ! -f "${CREDFILE}" ]; then
                error "No credential file named '$CREDFILE' found!"
            fi
            . $CREDFILE

            case "$CSP" in
                aws)
                    # Nothing to do
                    ;;
                openstack)
                    # define Openstack style variables based on native AWS ones
                    export OS_ACCESSKEY=$AWS_ACCESS_KEY_ID
                    export OS_SECRETKEY=$AWS_SECRET_ACCESS_KEY
                    ;;
                *)
                    error "provider '$CSP' not supported!"
                    ;;
            esac
            shift;shift;; 
        --) 
            shift; break;;
    esac
done

[ "x$ACTION" == "x" ] && error "--action required"
[ "x$CSP" == "x" ] && error "--provider required"

ansible-playbook $(dirname $0)/csp.${CSP}.${ACTION}.playbook.yml -e @$(dirname $0)/csp.${CSP}.vars.yml
