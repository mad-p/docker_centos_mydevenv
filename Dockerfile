FROM mad-p/centos-rails

MAINTAINER Kaoru Maeda <kaoru.maeda@gmail.com> mad-p

# setup sshd
ADD sshd/sshd_config /etc/ssh/sshd_config
# generate sshd keys
RUN /etc/init.d/sshd start;/etc/init.d/sshd stop

# install emacs23, curl, mysql
RUN yum install -y emacs curl mysql-client mysql-devel

# create user
RUN useradd -m -G rbenv maeda
RUN bash -c 'echo "maeda:maeda" | chpasswd'
RUN mkdir -p /home/maeda/.ssh
ADD sshd/authorized_keys /home/maeda/.ssh/authorized_keys
ADD sshd/known_hosts /home/maeda/.ssh/known_hosts
RUN chown -R maeda /home/maeda; chmod 700 /home/maeda/.ssh;chmod 600 /home/maeda/.ssh/authorized_keys
RUN chsh -s /usr/bin/zsh maeda

# setup sudoers
RUN echo "maeda ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/maeda; chmod 440 /etc/sudoers.d/maeda

# setup dotfiles
ADD install-dotfiles.sh /home/maeda/install-dotfiles.sh
RUN chown maeda /home/maeda/install-dotfiles.sh; chmod 755 /home/maeda/install-dotfiles.sh
USER maeda
ENV HOME /home/maeda
RUN sh /home/maeda/install-dotfiles.sh

USER root

CMD /usr/sbin/sshd -D
EXPOSE 2222
