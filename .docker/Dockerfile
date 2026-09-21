FROM python:alpine
WORKDIR /root

RUN : \
    && apk add --update --no-cache \
        aws-cli \
        binutils \
        coreutils \
        curl \
        findutils \
        fzf \
        gawk \
        git \
        grep \
        iproute2 \
        jo \
        jq \
        ncurses \
        ncurses-terminfo \
        openssh \
        pciutils \
        postgresql-client \
        redis \
        ripgrep \
        sed \
        tmux \
        usbutils \
        util-linux \
        vim \
        wget \
        zsh \
    && apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
		helm \
		kubectl \
    && mkdir -p /root/.wryn \
    ;

# alpine's newest yq (4.25) predates the '-r' flag scwrypts relies on, so
# take it from upstream releases instead
RUN : \
    && YQ_ARCH="$(uname -m)" \
    && case "${YQ_ARCH}" in \
        ( x86_64  ) YQ_ARCH=amd64 ;; \
        ( aarch64 ) YQ_ARCH=arm64 ;; \
       esac \
    && wget -qO /usr/local/bin/yq \
        "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" \
    && chmod +x /usr/local/bin/yq \
    && yq --version \
    ;

COPY . /root/.wryn

RUN : \
    && echo "#!/bin/zsh" > /bin/hostnamectl && echo "echo container" > /bin/hostnamectl && chmod +x /bin/hostnamectl \
    && echo "#!/bin/zsh" > /bin/scwrypts && echo '/root/.wryn/zsh/plugins/scwrypts/scwrypts $@' >> /bin/scwrypts && chmod +x /bin/scwrypts \
    && mkdir -p /root/.wryn/config/local/container/bin \
    && sed -i 's|/bin/ash|/bin/zsh|g' /etc/passwd \
    && /bin/zsh -c '/root/.wryn/setup/run --min --ci --force-root --no-logfile --skip config' \
    && echo 'source /root/.wryn/zsh/rc' > /root/.zshrc \
    && echo 'source /root/.wryn/config/dotwryn.env.zsh' > /root/.config/wryn/env.zsh \
    && echo "WELCOME() {}" >> /root/.config/wryn/env.zsh \
    && echo "PS1_INDICATOR_SYMBOL=''" >> /root/.config/wryn/env.zsh \
    && echo "PS1_USER=\"root@\$(ip a | grep inet | grep -v '127\\.0\\.0\.1' | sed 's|/| |g' | awk '{print \$2;}')\"" >> /root/.config/wryn/env.zsh \
    && echo "source /root/.wryn/zsh/plugins/scwrypts/scwrypts.plugin.zsh" >> /root/.config/wryn/env.zsh \
    ;

ENTRYPOINT ["/root/.wryn/.docker/entrypoint"]
