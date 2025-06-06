package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import dao.PatientDAO;
import dao.UtilisateurDAO;
import model.Patient;
import model.Utilisateur;

@WebServlet("/admin/ajouter-patient")
public class AdminPatientServlet extends HttpServlet {
    private PatientDAO patientDAO;
    private UtilisateurDAO utilisateurDAO;
    
    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
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
        
        request.getRequestDispatcher("/views/admin/ajouter_patient.jsp")
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
        
        try {
            // Create new Utilisateur
            Utilisateur utilisateur = new Utilisateur();
            utilisateur.setNom(request.getParameter("nom"));
            utilisateur.setPrenom(request.getParameter("prenom"));
            utilisateur.setEmail(request.getParameter("email"));
            utilisateur.setTelephone(request.getParameter("telephone"));
            utilisateur.setRole("patient");
            utilisateurDAO.save(utilisateur);
            
            // Create new Patient
            Patient patient = new Patient();
            patient.setUtilisateur(utilisateur);
            
            // Parse date string to Date object
            String dateNaissanceStr = request.getParameter("dateNaissance");
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dateNaissance = dateFormat.parse(dateNaissanceStr);
            patient.setDateNaissance(dateNaissance);
  		  	patient.setNumeroSecuriteSociale(request.getParameter("numeroSecuriteSociale"));
            patient.setGroupeSanguin(request.getParameter("groupeSanguin"));
            patient.setAntecedentsMedicaux(request.getParameter("antecedentsMedicaux"));
            
            patientDAO.save(patient);
            
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } catch (ParseException e) {
            request.setAttribute("error", "Format de date invalide");
            request.getRequestDispatcher("/views/admin/ajouter_patient.jsp")
                   .forward(request, response);
        }
    }
} 