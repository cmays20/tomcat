FROM tomcat:9
LABEL version="1.0"

RUN mv webapps.dist/ROOT webapps/tomcat
