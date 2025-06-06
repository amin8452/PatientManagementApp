package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import dao.MedecinDAO;
import dao.UtilisateurDAO;
import dao.SpecialiteDAO;
import model.Medecin;
import model.Utilisateur;
import model.Specialite;

@WebServlet("/admin/ajouter-medecin")
public class AdminMedecinServlet extends HttpServlet {
    private MedecinDAO medecinDAO;
    private UtilisateurDAO utilisateurDAO;
    private SpecialiteDAO specialiteDAO;
    
    @Override
    public void init() throws ServletException {
        medecinDAO = new MedecinDAO();
        utilisateurDAO = new UtilisateurDAO();
        specialiteDAO = new SpecialiteDAO();
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
        
        // Get all specialties for the form
        request.setAttribute("specialites", specialiteDAO.findAll());
        
        request.getRequestDispatcher("/views/admin/ajouter_medecin.jsp")
               .forward(request, response);
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
        
        // Create new Utilisateur
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setNom(request.getParameter("nom"));
        utilisateur.setPrenom(request.getParameter("prenom"));
        utilisateur.setEmail(request.getParameter("email"));
        utilisateur.setTelephone(request.getParameter("telephone"));
        utilisateur.setRole("medecin");
        utilisateurDAO.save(utilisateur);
        
        // Create new Medecin
        Medecin medecin = new Medecin();
        medecin.setUtilisateur(utilisateur);
        
        // Set specialty
        String specialiteId = request.getParameter("specialite");
        if (specialiteId != null && !specialiteId.isEmpty()) {
            Specialite specialite = specialiteDAO.findById(Integer.parseInt(specialiteId));
            medecin.setSpecialite(specialite);
        }
        
        medecinDAO.save(medecin);
        
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
} 