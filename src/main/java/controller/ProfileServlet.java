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

@WebServlet("/profil")
public class ProfileServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }
        
        request.getRequestDispatcher("views/profil.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        
        // Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String ancienMotDePasse = request.getParameter("ancienMotDePasse");
        String nouveauMotDePasse = request.getParameter("nouveauMotDePasse");
        
        // Vérifier si l'ancien mot de passe est correct
        if (ancienMotDePasse != null && !ancienMotDePasse.isEmpty()) {
            if (!ancienMotDePasse.equals(utilisateur.getMotDePasse())) {
                request.setAttribute("message", "L'ancien mot de passe est incorrect.");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("views/profil.jsp").forward(request, response);
                return;
            }
            
            // Mettre à jour le mot de passe
            if (nouveauMotDePasse != null && !nouveauMotDePasse.isEmpty()) {
                utilisateur.setMotDePasse(nouveauMotDePasse);
            }
        }
        
        // Mettre à jour les informations de l'utilisateur
        utilisateur.setNom(nom);
        utilisateur.setPrenom(prenom);
        utilisateur.setEmail(email);
        
        // Sauvegarder les modifications
        UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
        utilisateurDAO.update(utilisateur);
        
        // Mettre à jour la session
        session.setAttribute("utilisateur", utilisateur);
        
        // Rediriger avec un message de succès
        request.setAttribute("message", "Profil mis à jour avec succès.");
        request.setAttribute("messageType", "success");
        request.getRequestDispatcher("views/profil.jsp").forward(request, response);
    }
}