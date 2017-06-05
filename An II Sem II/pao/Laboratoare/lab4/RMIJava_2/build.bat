CLS 
@echo off
REM Comment above line if you  want to see comments here

REM Compiling service
javac service/MathOp.java
javac service/IGenerator.java

REM Compiling server 
javac rmi_test_server/MathOp_Concrete.java
javac rmi_test_server/Generator.java
javac rmi_test_server/RMI_1_Server.java

REM Compiling client
javac rmi_test_client/RMI_1.java

