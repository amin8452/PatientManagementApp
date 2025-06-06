package controller;

import java.io.IOException;
import java.util.List;

import dao.MedecinDAO;
import dao.RendezVousDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Medecin;
import model.RendezVous;
import model.Utilisateur;

@WebServlet("/medecin/rendez-vous/*")
public class MedecinRendezVousServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }
        
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (!"medecin".equals(utilisateur.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/" + utilisateur.getRole() + "/dashboard.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Liste des rendez-vous du médecin
            afficherListeRendezVous(request, response);
        } else if (pathInfo.equals("/accepter")) {
            // Accepter un rendez-vous
            accepterRendezVous(request, response);
        } else if (pathInfo.equals("/refuser")) {
            // Refuser un rendez-vous
            refuserRendezVous(request, response);
        } else if (pathInfo.equals("/detail")) {
            // Détail d'un rendez-vous
            afficherDetailRendezVous(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/medecin/rendez-vous");
        }
    }
    
    private void afficherListeRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
        
        MedecinDAO medecinDAO = new MedecinDAO();
        Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
        
        if (medecin == null) {
            response.sendRedirect(request.getContextPath() + "/medecin/dashboard");
            return;
        }
        
        RendezVousDAO rendezVousDAO = new RendezVousDAO();
        List<RendezVous> rendezVousList = rendezVousDAO.findByMedecin(medecin.getId());
        
        request.setAttribute("rendezVousList", rendezVousList);
        request.getRequestDispatcher("/views/medecin/rendez-vous.jsp").forward(request, response);
    }
    
    private void afficherDetailRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int rendezVousId = Integer.parseInt(request.getParameter("id"));
            
            RendezVousDAO rendezVousDAO = new RendezVousDAO();
            RendezVous rendezVous = rendezVousDAO.findById(rendezVousId);
            
            // Vérifier que le rendez-vous appartient bien au médecin connecté
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            MedecinDAO medecinDAO = new MedecinDAO();
            Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
            
            if (rendezVous != null && rendezVous.getMedecin().getId() == medecin.getId()) {
                request.setAttribute("rendezVous", rendezVous);
                request.getRequestDispatcher("/views/medecin/detail-rendez-vous.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/medecin/rendez-vous");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medecin/rendez-vous");
        }
    }
    
    private void accepterRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int rendezVousId = Integer.parseInt(request.getParameter("id"));
            
            RendezVousDAO rendezVousDAO = new RendezVousDAO();
            RendezVous rendezVous = rendezVousDAO.findById(rendezVousId);
            
            // Vérifier que le rendez-vous appartient bien au médecin connecté
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            MedecinDAO medecinDAO = new MedecinDAO();
            Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
            
            if (rendezVous != null && rendezVous.getMedecin().getId() == medecin.getId()) {
                rendezVous.setStatut("accepté");
                rendezVousDAO.update(rendezVous);
                
                request.getSession().setAttribute("message", "Le rendez-vous a été accepté.");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Une erreur est survenue lors de l'acceptation du rendez-vous.");
                request.getSession().setAttribute("messageType", "danger");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Une erreur est survenue lors de l'acceptation du rendez-vous.");
            request.getSession().setAttribute("messageType", "danger");
        }
        
        response.sendRedirect(request.getContextPath() + "/medecin/rendez-vous");
    }
    
    private void refuserRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int rendezVousId = Integer.parseInt(request.getParameter("id"));
            
            RendezVousDAO rendezVousDAO = new RendezVousDAO();
            RendezVous rendezVous = rendezVousDAO.findById(rendezVousId);
            
            // Vérifier que le rendez-vous appartient bien au médecin connecté
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            MedecinDAO medecinDAO = new MedecinDAO();
            Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
            
            if (rendezVous != null && rendezVous.getMedecin().getId() == medecin.getId()) {
                rendezVous.setStatut("refusé");
                rendezVousDAO.update(rendezVous);
                
                request.getSession().setAttribute("message", "Le rendez-vous a été refusé.");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Une erreur est survenue lors du refus du rendez-vous.");
                request.getSession().setAttribute("messageType", "danger");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Une erreur est survenue lors du refus du rendez-vous.");
            request.getSession().setAttribute("messageType", "danger");
        }
        
        response.sendRedirect(request.getContextPath() + "/medecin/rendez-vous");
    }
} 