# Bash Learn student environment.
FROM mcr.microsoft.com/devcontainers/base:bookworm

# Restore man pages if the base image excludes them, then install the tools used in the course.
# awk is mawk, as on Ubuntu: the lectures' locale examples (decimal comma) assume it.
RUN set -eux; \
    if ls /etc/dpkg/dpkg.cfg.d/* > /dev/null 2>&1; then sed -i '/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/*; fi; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      man-db manpages manpages-es manpages-dev locales \
      tree less procps psmisc file bc jq nano vim-tiny; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --reinstall --no-install-recommends \
      bash coreutils findutils grep sed mawk tar gzip util-linux; \
    apt-get purge -y gawk; update-alternatives --set awk /usr/bin/mawk; awk -W version 2>&1 | grep -q mawk; \
    sed -i 's/^# *\(es_ES.UTF-8\)/\1/' /etc/locale.gen; locale-gen; \
    mandb -q || true; \
    rm -rf /var/lib/apt/lists/*

# The student user is alu, as in the lectures (/home/alu), instead of the base image's vscode.
# It keeps its UID (1000), groups and passwordless sudo.
# The full name and the secondary group alumnos (GID 1001) match the week 5 examples.
RUN set -eux; \
    usermod -l alu -d /home/alu -m vscode; \
    groupmod -n alu vscode; \
    groupadd -g 1001 alumnos; \
    usermod -aG alumnos -c 'Alumno ULL' alu; \
    sed -i 's/^vscode /alu /' /etc/sudoers.d/vscode; \
    mv /etc/sudoers.d/vscode /etc/sudoers.d/alu; \
    grep -rlI /home/vscode /home/alu | xargs -r sed -i 's|/home/vscode|/home/alu|g'; \
    id alu; sudo -u alu sudo -n true

# The prompt shows the user (alu), not @GITHUB_USER, which Codespaces sets to the GitHub login.
RUN set -eux; \
    sed -i 's/\[ ! -z "\${GITHUB_USER:-}" \] && echo -n "[^"]*" || //' /home/alu/.bashrc /root/.bashrc; \
    ! grep -q GITHUB_USER /home/alu/.bashrc /root/.bashrc

ENV LANG=es_ES.UTF-8 \
    LANGUAGE=es_ES:es \
    CHECK_LANG=es

# The `check` command (shellcheck + bats-core tests).
COPY check /opt/check
RUN chmod +x /opt/check/bin/* /opt/check/vendor/bats-core/bin/* /opt/check/vendor/bats-core/libexec/bats-core/* \
    && ln -s /opt/check/bin/check /usr/local/bin/check

# shellcheck: the version pinned in check/vendor/VERSIONS, the same one `check --install-shellcheck`
# downloads outside the container.
RUN ln -s "$(CHECK_TOOLS_DIR=/opt/check/tools check --install-shellcheck)" /usr/local/bin/shellcheck \
    && shellcheck --version
