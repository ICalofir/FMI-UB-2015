<%@page import= "java.sql.*" %>
<%@ page import = "java.util.*"%>

<%! 
    Connection conn=null;

    public void jspInit()
    {
        try
        {
            conn = java.sql.DriverManager.getConnection("jdbc:derby://localhost:1527/Angajati", "radu", "12345");
        }
        catch(SQLException ex)
        {
        }
    }
    
    public void jspDestroy()
    {
        try
        {
            if (conn != null) conn.close();
        }
        catch(SQLException ex)
        {
        }
    }
%>

<html>
    <head><title>Aplicatie baza de date</title></head>
    <body>
        <%
            ResultSet rs=null;
            PreparedStatement pst=null;
            try {
                    String sql = "SELECT * FROM Angajati WHERE Salariu >= ? ORDER BY Salariu DESC";
                    pst = conn.prepareStatement(sql);
                    pst.setDouble(1, Double.parseDouble(request.getParameter("Salariu")));
                    rs = pst.executeQuery();
          
            %>
            <table border="1" cellspacing="0" cellpadding="10">
                <tr>
                 <td>Nume</td>
                 <td>Varsta</td>
                 <td>Salariu</td>
              </tr>
          <% 
            while(rs.next())
            {
             %>
             <tr>
                 <td><%= rs.getString("Nume")%></td>
                 <td><%= rs.getInt("Varsta")%></td>
                 <td><%= rs.getDouble("Salariu")%></td>
              </tr>
              
            <% 
                }
           %>
           </table>
        <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
               pst.close();
            }
        }

    %>
         
</body>
</html>