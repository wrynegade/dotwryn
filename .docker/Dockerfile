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
        ncurses \
        ncurses-terminfo \
        nodejs \
        npm \
        openssh \
        pciutils \
        postgresql \
        py3-virtualenv \
        py3-nodeenv \
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
	&& apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    && mkdir -p /root/.wryn \
    ;

COPY . /root/.wryn

RUN : \
    && echo "#!/bin/zsh" > /bin/hostnamectl && echo "echo container" > /bin/hostnamectl && chmod +x /bin/hostnamectl \
    && echo "#!/bin/zsh" > /bin/scwrypts && echo '/root/.wryn/zsh/plugins/scwrypts/scwrypts $@' >> /bin/scwrypts && chmod +x /bin/scwrypts \
    && mkdir /root/.wryn/bin/container \
    && sed -i 's|/bin/ash|/bin/zsh|g' /etc/passwd \
    && /bin/zsh -c '/root/.wryn/setup/run --no-fluff --ci --force-root' \
    && echo 'source /root/.wryn/config/dotwryn.env.zsh' > /root/.config/wryn/env.zsh \
    && echo "WELCOME() {}" >> /root/.config/wryn/env.zsh \
    && echo "PS1_INDICATOR_SYMBOL=''" >> /root/.config/wryn/env.zsh \
    && echo "PS1_USER=\"root@\$(ip a | grep inet | grep -v '127\\.0\\.0\.1' | sed 's|/| |g' | awk '{print \$2;}')\"" >> /root/.config/wryn/env.zsh \
    && echo "source /root/.wryn/zsh/plugins/scwrypts/scwrypts.plugin.zsh" >> /root/.config/wryn/env.zsh \
    && rm /root/dotwryn-install.log \
    && scwrypts --name scwrypts/virtualenv/update-all --group scwrypts --type zsh \
    ;

ENTRYPOINT ["/root/.wryn/.docker/entrypoint"]
