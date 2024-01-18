FROM jenkins/jenkins:2.426.2-lts-jdk17
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY --chown=jenkins:jenkins  jenkins.yaml /var/jenkins_home/jenkins.yaml
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
