FROM maven:3-jdk-8-alpine

RUN set -x && \
    apk add --no-cache bash

VOLUME ${MAVEN_HOME}/.m2/repository

# Required from a licensing standpoint
ADD ./LICENSE /opt/swagger-codegen/LICENSE3

# Required to compile swagger-codegen
ADD ./google_checkstyle.xml /opt/swagger-codegen/google_checkstyle.xml

# Modules are copied individually here to allow for caching of docker layers between major.minor versions
# NOTE: swagger-generator is not included here, it is available as swaggerapi/swagger-generator
ADD ./modules/swagger-codegen-maven-plugin /opt/swagger-codegen/modules/swagger-codegen-maven-plugin
ADD ./modules/swagger-codegen-cli /opt/swagger-codegen/modules/swagger-codegen-cli
ADD ./modules/swagger-codegen /opt/swagger-codegen/modules/swagger-codegen
ADD ./modules/swagger-generator /opt/swagger-codegen/modules/swagger-generator
ADD ./pom.xml /opt/swagger-codegen/pom.xml

# Pre-compile swagger-codegen-cli
RUN mvn -f /opt/swagger-codegen -am -pl "modules/swagger-codegen-cli" package

# This exists at the end of the file to benefit from cached layers when modifying docker-entrypoint.sh.
ADD ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["help"]