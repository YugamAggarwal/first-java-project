FROM openjdk:11

COPY jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar demo-workshop-2.1.2.jar

ENTRYPOINT ["java", "-jar", "demo-workshop-2.1.2.jar"]
