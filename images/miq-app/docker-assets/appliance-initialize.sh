#!/bin/sh

[[ -s /etc/default/evm ]] && source /etc/default/evm

# Source OpenShift scripting env
[[ -s ${CONTAINER_SCRIPTS_ROOT}/container-deploy-common.sh ]] && source "${CONTAINER_SCRIPTS_ROOT}/container-deploy-common.sh"

# Delay in seconds before we init, allows rest of services to settle
sleep "${APPLICATION_INIT_DELAY}"

# Check Memcached readiness
check_svc_status ${MEMCACHED_SERVICE_NAME} 11211

# Check DB readiness
check_svc_status ${DATABASE_SERVICE_NAME} 5432

write_v2_key

write_guid

cd ${APP_ROOT}
bin/rake evm:deployment_status

# Select path of action based on DEPLOYMENT_STATUS value
case $? in
  3) # new_deployment
    echo "== Starting New Deployment =="
    # Generate the certs
    /usr/bin/generate_miq_server_cert.sh

    # Run appliance_console_cli to init appliance
    init_appliance
  ;;
  4) # new_replica
    echo "New replica is not supported, exiting.."
    exit 1
  ;;
  5) # redeployment
    echo "== Starting Re-deployment =="
  ;;
  6) # upgrade
    echo "== Starting Upgrade =="
    run_hook pre-upgrade
    migrate_db
    run_hook post-upgrade
  ;;
  *)
    echo "Could not find a suitable deployment type, exiting.."
    exit 1
esac
