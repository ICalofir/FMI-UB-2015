<%@page import="java.util.Scanner"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Numere prime</title>
    </head>
    <body>
        
        <form method="GET">
            <label>Valoarea maximă: </label><input type="text" name="nrmax">
            <button type="submit">Generează!</button>
        </form>
 
        <%
            String aux = request.getParameter("nrmax");
            
            if(aux != null)
            {
                Scanner in = new Scanner(aux);
                if(!in.hasNextInt())
                {
        %>
                    <h2 align = "center">Valoarea <%= aux %> nu este un număr întreg!</h2>
                    <%
                }
                else
                {
                    int n = in.nextInt();
                    int i , d;
                %>
                    <h2 align = "center">Numerele prime mai mici sau egale decât <%= n %>:</h2>
                    <br/>
                <%
                    for (i = 2; i < n; i++)
                    {
                        for(d = 2; d <= i/2; d++)
                        {
                            if(i % d == 0) break;
                        }
                        
                        if(d > i/2)
                        {
                %>
                            <span> <font size = "4"> <b> <%= i %> </b> </font></span>
                  <%
                    }
                    }
                }
            }
       %>
    </body>
</html>
