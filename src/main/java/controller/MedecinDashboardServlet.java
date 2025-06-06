package controller;

import dao.DossierMedicalDAO;
import dao.PatientDAO;
import dao.RendezVousDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;
import java.io.IOException;
import java.util.Date;

@WebServlet("/medecin/dashboard")
public class MedecinDashboardServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private RendezVousDAO rendezVousDAO = new RendezVousDAO();
    private DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"medecin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        // Get today's appointments
        request.setAttribute("nombreRendezVousAujourdhui", 
            rendezVousDAO.countByMedecinAndDate(user.getId(), new Date()));

        // Get total number of patients
        request.setAttribute("nombrePatients", 
            patientDAO.countByMedecin(user.getId()));

        // Get total number of medical records
        request.setAttribute("nombreDossiers", 
            dossierMedicalDAO.countByMedecin(user.getId()));

        // Forward to dashboard JSP
        request.getRequestDispatcher("/views/medecin/dashboard.jsp")
               .forward(request, response);
    }
} 