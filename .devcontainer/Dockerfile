# Student environment of the Bash course.
FROM mcr.microsoft.com/devcontainers/base:bookworm

# Restore man pages if the base image excludes them, then install the tools used in the course.
# The course calls gawk directly (awk may be mawk on other systems).
RUN set -eux; \
    if ls /etc/dpkg/dpkg.cfg.d/* > /dev/null 2>&1; then sed -i '/usr\/share\/man/d' /etc/dpkg/dpkg.cfg.d/*; fi; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      man-db manpages manpages-es manpages-dev locales \
      tree less procps psmisc lsof file bc jq nano vim-tiny; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --reinstall --no-install-recommends \
      bash coreutils findutils grep sed gawk mawk tar gzip util-linux; \
    gawk --version | head -n 1; \
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

# shellcheck: the version pinned in .course/check/vendor/VERSIONS, the same one `check --setup`
# downloads outside the container. `check` itself runs from the repository (remoteEnv PATH).
COPY .course/check /tmp/check
RUN CHECK_TOOLS_DIR=/opt/shellcheck /tmp/check/bin/check --setup > /dev/null \
    && ln -s /opt/shellcheck/shellcheck-*/shellcheck /usr/local/bin/shellcheck \
    && rm -rf /tmp/check \
    && shellcheck --version
