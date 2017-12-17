FROM alpine:latest
LABEL maintainer "jmc.leira@gmail.com"

# Install dependencies
RUN apk add --update --virtual build-deps \
  build-base \
  ctags \
  git \
  libx11-dev \
  libxpm-dev \
  libxt-dev \
  make \
  ncurses-dev \
  python \
  python-dev \
  bash \
  zsh \
  git \
  python \
  cmake \
  openssh-client

RUN git clone https://github.com/vim/vim.git /tmp/vim \
    && cd /tmp/vim \
    && ./configure --with-features=huge \
                   --enable-multibyte \
                   --enable-rubyinterp=yes \
                   --enable-pythoninterp=yes \
                   --enable-python3interp=yes \
                   --with-python-config-dir=/usr/lib/python2.7/config \
                   --enable-perlinterp=yes \
                   --enable-luainterp=yes \
                   --enable-gui=gtk2 \
                   --enable-cscope \
                   --prefix=/usr/local \
    && make install

# Creates a custom user to avoid using root
# We do also force the 2000 UID to match the host
# user and avoid permissions problems
# There are some issues about it:
# https://github.com/docker/docker/issues/2259
# https://github.com/nodejs/docker-node/issues/289
RUN  adduser -D -u 2000 dev

# Configure the dev user
USER dev
WORKDIR /home/dev

# Install oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Instal fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /home/dev/.fzf \
    && /home/dev/.fzf/install --bin

# Download my personal dotfiles
RUN git clone https://github.com/jcorral/dotfiles.git /home/dev/dotfiles \
  && cd /home/dev/dotfiles \
  && git submodule update --init --recursive

# Make vim's custom preferences & zsh's profile available for the dev user
RUN ln -fs /home/dev/dotfiles/.zshrc /home/dev/.zshrc \
 && ln -fs /home/dev/dotfiles/.vim /home/dev/.vim \
 && ln -fs /home/dev/dotfiles/.vimrc /home/dev/.vimrc

# Configure the .vim YouCompleteMe plugin
RUN /home/dev/dotfiles/.vim/bundle/YouCompleteMe/install.py
