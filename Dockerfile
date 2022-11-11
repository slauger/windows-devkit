FROM registry.access.redhat.com/ubi9/ubi as builder

# renovate: datasource=github-tags depName=stedolan/jq
ENV JQ_VERSION=jq-1.6

# renovate: datasource=github-tags depName=mikefarah/yq
ENV YQ_VERSION=v4.28.2

# renovate: datasource=github-tags depName=kubernetes/kubectl
ENV KUBECTL_VERSION=v1.25.0

# renovate: datasource=docker depName=quay.io/openshift-release-dev/ocp-release versioning=loose
ENV OPENSHIFT_VERSION=4.11.11

# renovate: datasource=github-tags depName=tektoncd/cli
ENV TKN_VERSION=0.25.1

# renovate: datasource=github-tags depName=helm/helm
ENV HELM_VERSION=v3.10.1

# renovate: datasource=github-tags depName=helmfile/helmfile
ENV HELMFILE_VERSION=0.147.0

# renovate: datasource=github-tags depName=norwoodj/helm-docs
ENV HELM_DOCS_VERSION=1.11.0

# renovate: datasource=gihub-tags depName=kubernetes-sigs/krew
ENV KREW_VERSION=v0.4.3

# renovate: datasource=github-tags depName=ahmetb/kubectx
ENV KUBECTX_VERSION=v0.9.4

# renovate: datasource=github-tags depName=grafana/k6
ENV K6_VERSION=0.41.0

# renovate: datasource=github-tags depName=cmderdev/cmder
ENV CMDER_VERSION=v1.3.20

RUN mkdir -p /opt/binaries /opt/tools && \
    yum install -y unzip

# jq
RUN curl -fsSL -o /opt/binaries/jq.exe https://github.com/stedolan/jq/releases/download/${JQ_VERSION}/jq-win64.exe

# yq
RUN curl -fsSL -o /opt/binaries/yq.exe https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_windows_amd64.exe

# kubectl
RUN curl -fsSL -o /opt/binaries/kubectl.exe https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/windows/amd64/kubectl.exe

# oc
RUN curl -fsSL -o openshift-client-windows.zip https://mirror.openshift.com/pub/openshift-v4/amd64/clients/ocp/4.10.0/openshift-client-windows.zip && \
    unzip openshift-client-windows.zip oc.exe && \
    mv oc.exe /opt/binaries/oc.exe && \
    rm openshift-client-windows.zip

# tkn
RUN curl -fsSL -o tkn_Windows_x86_64.zip https://github.com/tektoncd/cli/releases/download/v0.25.1/tkn_0.25.1_Windows_x86_64.zip && \
    unzip tkn_Windows_x86_64.zip tkn.exe && \
    mv tkn.exe /opt/binaries/tkn.exe && \
    rm tkn_Windows_x86_64.zip

# helm
RUN curl -fsSL -o helm-windows-amd64.zip https://get.helm.sh/helm-${HELM_VERSION}-windows-amd64.zip && \
    unzip helm-windows-amd64.zip && \
    mv windows-amd64/helm.exe /opt/binaries/helm.exe && \
    rm -rf windows-amd64 helm-windows-amd64.zip

# helmfile
RUN curl -fsSL -o helmfile_windows_arm64.tar.gz https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_windows_arm64.tar.gz && \
    tar xzf helmfile_windows_arm64.tar.gz helmfile.exe && \
    mv helmfile.exe /opt/binaries/helmfile.exe && \
    rm helmfile_windows_arm64.tar.gz

RUN curl -fsSL -o helm-docs_Windows_x86_64.tar.gz https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_Windows_x86_64.tar.gz && \
    tar vxzf helm-docs_Windows_x86_64.tar.gz helm-docs.exe && \
    mv helm-docs.exe /opt/binaries/helm-docs.exe && \
    rm -rf helm-docs_Windows_x86_64.tar.gz

# krew
RUN curl -fsSL -o krew-windows_amd64.tar.gz https://github.com/kubernetes-sigs/krew/releases/download/${KREW_VERSION}/krew-windows_amd64.tar.gz && \
    tar vxzf krew-windows_amd64.tar.gz ./krew-windows_amd64.exe && \
    mv krew-windows_amd64.exe /opt/binaries/krew.exe && \
    rm krew-windows_amd64.tar.gz

# kubectx
RUN curl -fsSL -o kubectx_windows_x86_64.zip https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION}_windows_x86_64.zip && \
    unzip kubectx_windows_x86_64.zip kubectx.exe && \
    mv kubectx.exe /opt/binaries/kubectx.exe && \
    rm kubectx_windows_x86_64.zip

# kubens
RUN curl -fsSL -o kubens_windows_x86_64.zip https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubens_${KUBECTX_VERSION}_windows_x86_64.zip && \
    unzip kubens_windows_x86_64.zip kubens.exe && \
    mv kubens.exe /opt/binaries/kubens.exe && \
    rm kubens_windows_x86_64.zip

# k6
RUN curl -fsSL -o k6-v${K6_VERSION}-windows-amd64.zip https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-windows-amd64.zip && \
    unzip k6-v${K6_VERSION}-windows-amd64.zip k6-v${K6_VERSION}-windows-amd64/k6.exe && \
    mv k6-*-windows-amd64/k6.exe /opt/binaries/k6.exe && \
    rm -rf k6-v${K6_VERSION}-windows-amd64.zip

# VSC
RUN curl -fsSL -o /opt/tools/VSCode-win32-x64.zip "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"

# Mobaxterm
RUN curl -fsSL -o /opt/tools/MobaXterm_Portable.zip $(curl -s https://mobaxterm.mobatek.net/download-home-edition.html | egrep -o --color 'https\:\/\/download\.mobatek\.net/[0-9]+\/MobaXterm_Installer_v[0-9]+\.[0-9]\.zip' | sort | uniq | tail -n 1)

# Cmder
RUN curl -fsSL -o /opt/tools/cmder.zip https://github.com/cmderdev/cmder/releases/download/${CMDER_VERSION}/cmder.zip

FROM registry.access.redhat.com/ubi9/httpd-24

RUN sed -i 's/Listen 0.0.0.0:8080/Listen 0.0.0.0:1337/g' /etc/httpd/conf/httpd.conf

COPY --from=builder /opt/binaries /var/www/html/binaries
COPY --from=builder /opt/tools /var/www/html/tools

RUN tar vcf /var/www/html/binaries.tar.gz -C /var/www/html/binaries . && \
    cat /var/www/html/binaries.tar.gz | base64 -w0 > /var/www/html/binaries.tar.gz.base64 && \
    gzip /var/www/html/binaries.tar.gz.base64 && \
    rm /var/www/html/binaries.tar.gz && \
    tar vcf /var/www/html/tools.tar.gz -C /var/www/html/tools . && \
    cat /var/www/html/tools.tar.gz | base64 -w0 > /var/www/html/tools.tar.gz.base64 && \
    gzip /var/www/html/tools.tar.gz.base64 && \
    rm /var/www/html/tools.tar.gz
