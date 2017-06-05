package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.Scanner;

public final class JSP_005fNumere_005fprime_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      response.setContentType("text/html;charset=UTF-8");
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
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("    <head>\n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("        <title>Numere prime</title>\n");
      out.write("    </head>\n");
      out.write("    <body>\n");
      out.write("        ");

            String aux = request.getParameter("nrmax");
            if (aux != null) {
                Scanner in = new Scanner(aux);
                if (!in.hasNext()) {

        
      out.write("\n");
      out.write("        <h2 align=\"center\">Valoarea ");
      out.print( aux);
      out.write(" nu este intreaga!!!</h2>\n");
      out.write("        ");

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
               
      out.write("\n");
      out.write("               <span><font size=\"4\"><b>");
      out.print( i);
      out.write("</b></font></span>\n");
      out.write("               ");

                }
            }
        }
 
   
      out.write("\n");
      out.write("    <br/><br/>\n");
      out.write("    <a href = \"http://localhost:8080/JSP_3_Numere_prime_cu_doua_pagini/index.html\">Back</a>           \n");
      out.write("    </body>\n");
      out.write("</html>\n");
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
