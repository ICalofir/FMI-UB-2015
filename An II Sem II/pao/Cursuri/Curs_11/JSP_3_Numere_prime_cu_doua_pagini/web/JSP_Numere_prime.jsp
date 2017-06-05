<%@page import="java.util.Scanner"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Numere prime</title>
    </head>
    <body>
        <%
            String aux = request.getParameter("nrmax");
            if (aux != null) {
                Scanner in = new Scanner(aux);
                if (!in.hasNext()) {

        %>
        <h2 align="center">Valoarea <%= aux%> nu este intreaga!!!</h2>
        <%
                }
            int n=in.nextInt();
            int d,i;
            
            for(i=2;i<n;i++)
            {
                for(d=2;d<=i/2;d++)
                {
                    if(i%d==0) break;
                }
                if(d>i/2)
                {
               %>
               <span><font size="4"><b><%= i%></b></font></span>
               <%
                }
            }
        }
 
   %>
    <br/><br/>
    <a href = "http://localhost:8080/JSP_3_Numere_prime_cu_doua_pagini/index.html">Back</a>           
    </body>
</html>
