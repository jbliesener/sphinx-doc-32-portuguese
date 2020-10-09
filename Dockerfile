#
# jbliesener/sphinx-doc-portuguese
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t jbliesener/sphinx-doc-32-portuguese .

FROM       python:3.9.0-buster
MAINTAINER Jorg Neves Bliesener

RUN gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && curl -o /usr/local/bin/gosu     -SL "https://github.com/tianon/gosu/releases/download/1.12/gosu-$(dpkg --print-architecture)" \
 && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.12/gosu-$(dpkg --print-architecture).asc" \
 && gpg --verify /usr/local/bin/gosu.asc \
 && rm /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu

RUN export DEBIAN_FRONTEND=noninteractive \
 && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
 && apt-get update -y -q \
 && apt-get install -y software-properties-common \
 && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
 && apt-get update \
 && apt-get install -y -q --no-install-recommends dvipng graphviz adoptopenjdk-8-hotspot sudo texlive texlive-lang-french texlive-latex-extra \
 && apt-get install -y -q texlive-lang-portuguese latexmk \
 && apt-get upgrade -y -q \
 && apt-get autoremove -y -q \
 && rm -rf /var/cache/* \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
 && pip install 'Sphinx                        == 3.2.1'  \
                'alabaster                     == 0.7.12' \
                'recommonmark                  == 0.6.0'  \
                'sphinx-autobuild              == 2020.9.1'  \
                'sphinx-bootstrap-theme        == 0.7.1'  \
                'sphinx-prompt                 == 1.3.0'  \
                'sphinx_rtd_theme              == 0.5.0'  \
                'sphinxcontrib-actdiag         == 2.0.0'  \
                'sphinxcontrib-blockdiag       == 2.0.0'  \
                'sphinxcontrib-exceltable      == 0.2.2'  \
                'sphinxcontrib-googleanalytics == 0.1'    \
                'sphinxcontrib-googlechart     == 0.2.1'  \
                'sphinxcontrib-googlemaps      == 0.1.0'  \
                'sphinxcontrib-nwdiag          == 2.0.0'  \
                'sphinxcontrib-plantuml        == 0.18.1' \
                'sphinxcontrib-seqdiag         == 2.0.0'  \
                'livereload                    == 2.6.3'  \
                'docxbuilder[math]             == 1.2.0'

# RUN pip install sphinxcontrib-libreoffice == 0.2  # doesn't work

COPY files/opt/plantuml/*  /opt/plantuml/
COPY files/usr/local/bin/* /usr/local/bin/

RUN chown root:root /usr/local/bin/* \
 && chmod 755 /usr/local/bin/*

ENV DATA_DIR=/doc \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR $DATA_DIR

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
