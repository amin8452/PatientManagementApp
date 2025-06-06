package controller;

import dao.DossierMedicalDAO;
import dao.MedecinDAO;
import dao.PatientDAO;
import dao.RendezVousDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Patient;
import model.Utilisateur;
import java.io.IOException;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private MedecinDAO medecinDAO = new MedecinDAO();
    private RendezVousDAO rendezVousDAO = new RendezVousDAO();
    private DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Find the patient record first
            Patient patient = patientDAO.findByUtilisateur(user.getId());
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            // Get patient's upcoming appointments
            request.setAttribute("prochainsRendezVous", 
                rendezVousDAO.findByPatient(patient.getId()));

            // Get patient's medical record
            request.setAttribute("dossierMedical", 
                dossierMedicalDAO.findByPatient(patient.getId()));

            // Get available doctors
            request.setAttribute("medecins", 
                medecinDAO.findAll());

            // Forward to dashboard JSP
            request.getRequestDispatcher("/views/patient/dashboard.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/auth/login");
        }
    }
} 