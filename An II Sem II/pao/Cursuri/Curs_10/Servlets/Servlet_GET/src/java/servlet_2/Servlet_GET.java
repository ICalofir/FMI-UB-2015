package servlet_2;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Cristina
 */
@WebServlet(urlPatterns = {"/Servlet_GET"})
public class Servlet_GET extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Angajat</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1> Nume: " + request.getParameter("nume") + "</h1>");
            out.println("<h1> Varsta: " + request.getParameter("varsta") + "</h1>");
            out.println("<h1> Salariu: " + request.getParameter("salariu") + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

}
