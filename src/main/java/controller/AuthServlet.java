package controller;

import java.io.IOException;

import dao.UtilisateurDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        UtilisateurDAO dao = new UtilisateurDAO();
        Utilisateur user = dao.findByEmailAndPassword(email, motDePasse);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("utilisateur", user);
            session.setAttribute("role", user.getRole());

            String contextPath = request.getContextPath();
            switch (user.getRole()) {
                case "admin": 
                    response.sendRedirect(contextPath + "/admin/dashboard"); 
                    break;
                case "medecin": 
                    response.sendRedirect(contextPath + "/medecin/dashboard"); 
                    break;
                case "patient": 
                    response.sendRedirect(contextPath + "/patient/dashboard"); 
                    break;
                default: 
                    response.sendRedirect(contextPath + "/views/login.jsp?error=role"); 
                    break;
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp?error=invalid");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
    }
}