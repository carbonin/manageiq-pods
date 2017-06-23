FROM carbonin/manageiq-pods:app-latest
MAINTAINER ManageIQ https://github.com/ManageIQ/manageiq-appliance-build

## Atomic/OpenShift Labels
LABEL name="manageiq-worker" \
      vendor="ManageIQ" \
      version="Master" \
      release=${REF} \
      url="http://manageiq.org/" \
      summary="ManageIQ worker image" \
      description="ManageIQ is a management and automation platform for virtual, private, and hybrid cloud infrastructures." \
      io.k8s.display-name="ManageIQ Worker" \
      io.k8s.description="ManageIQ is a management and automation platform for virtual, private, and hybrid cloud infrastructures." \
      io.openshift.tags="ManageIQ,miq,manageiq"

COPY docker-assets/entrypoint /usr/bin
