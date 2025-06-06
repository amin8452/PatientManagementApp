package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Patient;
import model.Utilisateur;
import dao.PatientDAO;

import java.io.IOException;

@WebServlet("/patient/profile")
public class PatientProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

        if (utilisateur == null || !"patient".equals(utilisateur.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
            
            if (patient == null) {
                // Create a new patient record if it doesn't exist
                patient = new Patient();
                patient.setUtilisateur(utilisateur);
                patientDAO.save(patient);
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/views/patient/profile.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue lors de l'accès à votre profil");
            request.getRequestDispatcher("/views/patient/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

        if (utilisateur == null || !"patient".equals(utilisateur.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            // Update patient information
            patient.setNumeroSecuriteSociale(request.getParameter("numeroSecuriteSociale"));
            patient.setDateNaissance(java.sql.Date.valueOf(request.getParameter("dateNaissance")));
            patient.setGroupeSanguin(request.getParameter("groupeSanguin"));
            patient.setAntecedentsMedicaux(request.getParameter("antecedentsMedicaux"));

            // Update user information
            utilisateur.setEmail(request.getParameter("email"));
            
            // Update password if provided
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            if (password != null && !password.isEmpty() && password.equals(confirmPassword)) {
                utilisateur.setMotDePasse(password);
            }

            // Save changes
            patientDAO.update(patient);

            // Redirect back to profile page
            response.sendRedirect(request.getContextPath() + "/patient/profile");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Une erreur est survenue lors de la mise à jour du profil");
            request.getRequestDispatcher("/views/patient/dashboard.jsp").forward(request, response);
        }
    }
} 