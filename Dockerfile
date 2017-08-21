# Galaxy - BeerDeCoded
#
# VERSION 0.1

FROM quay.io/bebatut/asaim-framework

MAINTAINER Bérénice Batut, berenice.batut@gmail.com

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="BeerDeCoded"

# Import workflows, install the tool databases and start the data managers
COPY workflows/* $GALAXY_ROOT/workflows/
RUN startup_lite && \
    sleep 30 && \
    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD
    
# Add Container Style
COPY config/welcome.html $GALAXY_CONFIG_DIR/web/welcome.html
COPY config/beerdecoded_logo.png $GALAXY_CONFIG_DIR/web/beerdecoded_logo.png
