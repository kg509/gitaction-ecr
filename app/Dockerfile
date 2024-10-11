# 공식 OpenJDK 17 런타임 이미지를 기반으로 합니다.
# 이 이미지는 Java 애플리케이션을 실행하기 위한 JDK 17 환경을 제공합니다.
FROM openjdk:17-jdk-alpine

# 컨테이너 내에서 작업 디렉토리를 /app으로 설정합니다.
# 이 디렉토리는 이후 모든 명령어 실행의 기준이 됩니다.
WORKDIR /app

# Maven Wrapper 스크립트(mvnw)와 필요한 파일들을 컨테이너로 복사합니다.
# mvnw는 Maven을 실행하기 위한 스크립트이며, .mvn 디렉토리에는 Maven 설정 파일들이 포함되어 있습니다.
COPY mvnw .
COPY .mvn .mvn

# mvnw 스크립트에 실행 권한을 부여합니다.
# 이로써 스크립트를 실행 가능하게 하여 Maven 명령을 사용할 수 있습니다.
RUN chmod +x mvnw

# 프로젝트의 의존성 관리 파일인 pom.xml을 컨테이너로 복사합니다.
# 이 파일에는 프로젝트에 필요한 라이브러리와 플러그인이 정의되어 있습니다.
COPY pom.xml .

# 의존성 및 플러그인 다운로드를 수행합니다.
# 이 명령어는 프로젝트에 필요한 모든 라이브러리들을 다운로드하여 로컬 Maven 리포지토리에 캐시합니다.
# 이를 통해 나중에 애플리케이션을 빌드할 때 빠르게 진행할 수 있습니다.
RUN ./mvnw dependency:resolve

# 애플리케이션의 소스 코드와 기타 리소스 파일들을 컨테이너로 복사합니다.
# src 디렉토리에는 Java 소스 코드, 리소스 파일 등이 포함되어 있습니다.
COPY src ./src

# 애플리케이션을 빌드합니다.
# Maven을 사용하여 소스 코드를 컴파일하고, 애플리케이션 JAR 파일을 생성합니다.
RUN ./mvnw clean package

# 컨테이너 외부에서 애플리케이션에 접근할 수 있도록 80 포트를 오픈합니다.
# 이 포트는 Spring Boot 애플리케이션이 HTTP 요청을 수신할 기본 포트입니다.
EXPOSE 80

# JVM 메모리 설정과 함께 애플리케이션을 실행하는 명령어를 정의합니다.
# -Xmx512m 옵션은 JVM이 사용할 수 있는 최대 힙 메모리를 512MB로 제한합니다.
# 이 명령어는 컨테이너가 시작될 때 Spring Boot 애플리케이션을 실행합니다.
ENTRYPOINT ["./mvnw", "spring-boot:run", "-Dspring-boot.run.jvmArguments=-Xmx512m"]
