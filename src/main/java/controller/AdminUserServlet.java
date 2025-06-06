package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import dao.UtilisateurDAO;
import model.Utilisateur;

@WebServlet("/admin/gestion-utilisateurs/*")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UtilisateurDAO utilisateurDAO;

    @Override
    public void init() throws ServletException {
        utilisateurDAO = new UtilisateurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // List all users
            List<Utilisateur> utilisateurs = utilisateurDAO.findAll();
            request.setAttribute("utilisateurs", utilisateurs);
            request.getRequestDispatcher("/views/admin/gestion_utilisateurs.jsp")
                   .forward(request, response);
        } else if (pathInfo.equals("/modifier")) {
            // Show edit form
            String id = request.getParameter("id");
            if (id != null) {
                Utilisateur utilisateur = utilisateurDAO.findById(Integer.parseInt(id));
                if (utilisateur != null) {
                    request.setAttribute("utilisateur", utilisateur);
                    request.getRequestDispatcher("/views/admin/modifier_utilisateur.jsp")
                           .forward(request, response);
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/gestion-utilisateurs");
        } else if (pathInfo.equals("/supprimer")) {
            // Delete user
            String id = request.getParameter("id");
            if (id != null) {
                utilisateurDAO.delete(Integer.parseInt(id));
            }
            response.sendRedirect(request.getContextPath() + "/admin/gestion-utilisateurs");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle form submission
            String action = request.getParameter("action");
            if ("ajouter".equals(action)) {
                // Add new user
                Utilisateur newUser = new Utilisateur();
                newUser.setNom(request.getParameter("nom"));
                newUser.setPrenom(request.getParameter("prenom"));
                newUser.setEmail(request.getParameter("email"));
                newUser.setMotDePasse(request.getParameter("motDePasse"));
                newUser.setRole(request.getParameter("role"));
                
                utilisateurDAO.save(newUser);
            } else if ("modifier".equals(action)) {
                // Update existing user
                String id = request.getParameter("id");
                if (id != null) {
                    Utilisateur existingUser = utilisateurDAO.findById(Integer.parseInt(id));
                    if (existingUser != null) {
                        existingUser.setNom(request.getParameter("nom"));
                        existingUser.setPrenom(request.getParameter("prenom"));
                        existingUser.setEmail(request.getParameter("email"));
                        String newPassword = request.getParameter("motDePasse");
                        if (newPassword != null && !newPassword.isEmpty()) {
                            existingUser.setMotDePasse(newPassword);
                        }
                        existingUser.setRole(request.getParameter("role"));
                        
                        utilisateurDAO.update(existingUser);
                    }
                }
            }
        } else if (pathInfo.equals("/supprimer")) {
            // Delete user
            String id = request.getParameter("id");
            if (id != null) {
                utilisateurDAO.delete(Integer.parseInt(id));
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/gestion-utilisateurs");
    }
} 