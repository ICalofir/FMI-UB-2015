package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;

public final class JSP_005fBaza_005fde_005fdate_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("    <head><title>Aplicatie baza de date</title></head>\n");
      out.write("    <body>\n");
      out.write("        ");

            
            Connection conn=null;
            ResultSet rs=null;
            PreparedStatement pst=null;
            try {
                conn = java.sql.DriverManager.getConnection("jdbc:derby://localhost:1527/Angajati", "radu", "12345");
                
                String sql = "SELECT * FROM Angajati WHERE Salariu >= ? ORDER BY Salariu DESC";
                pst = conn.prepareStatement(sql);
                pst.setDouble(1, Double.parseDouble(request.getParameter("Salariu")));
                rs = pst.executeQuery();
          
            
      out.write("\n");
      out.write("            <table border=\"1\" cellspacing=\"0\" cellpadding=\"10\">\n");
      out.write("                <tr>\n");
      out.write("                 <td>Nume</td>\n");
      out.write("                 <td>Varsta</td>\n");
      out.write("                 <td>Salariu</td>\n");
      out.write("              </tr>\n");
      out.write("          ");
 
            while(rs.next())
            {
             
      out.write("\n");
      out.write("             <tr>\n");
      out.write("                 <td>");
      out.print( rs.getString("Nume"));
      out.write("</td>\n");
      out.write("                 <td>");
      out.print( rs.getInt("Varsta"));
      out.write("</td>\n");
      out.write("                 <td>");
      out.print( rs.getDouble("Salariu"));
      out.write("</td>\n");
      out.write("              </tr>\n");
      out.write("              \n");
      out.write("   ");
 
                }
           
      out.write("\n");
      out.write("           </table>\n");
      out.write("        ");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
               pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

    
      out.write("\n");
      out.write("         \n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
