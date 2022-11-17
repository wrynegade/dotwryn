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
	&& apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
		kubectl \
    && mkdir -p /root/.wryn \
    ;

COPY . /root/.wryn

RUN : \
    && /bin/zsh -c '/root/.wryn/setup/run --no-fluff --ci --force-root' \
    && echo 'hostnamectl() { echo docker; }' > $HOME/.config/wryn/env.zsh \
    && echo 'source /root/.wryn/config/dotwryn.env.zsh' >> $HOME/.config/wryn/env.zsh \
    && echo "WELCOME() {}" >> $HOME/.config/wryn/env.zsh \
    && echo "PS1_INDICATOR_SYMBOL=''" >> $HOME/.config/wryn/env.zsh \
    && echo "PS1_USER='root@debugger'" >> $HOME/.config/wryn/env.zsh \
    && rm /root/dotwryn-install.log \
    ;

ENTRYPOINT ["/root/.wryn/.docker/entrypoint"]
