FROM bitnami/java:17 as base

ARG JDBC_URL="jdbc:postgresql://localhost:5432/db?user=app&password=pass"
ENV JDBC_URL ${JDBC_URL}

WORKDIR /app

COPY src/.mvn/ .mvn
COPY src/mvnw src/pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:resolve

COPY ./src ./
RUN chmod +x mvnw
RUN ./mvnw verify

FROM bitnami/java:17
COPY --from=base /app/target/app.jar ./app.jar
EXPOSE 8080
ENTRYPOINT ["./app.jar"]