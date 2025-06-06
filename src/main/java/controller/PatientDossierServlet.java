package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import dao.DossierMedicalDAO;
import dao.PatientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DossierMedical;
import model.DocumentMedical;
import model.Patient;
import model.Utilisateur;

@WebServlet("/patient/dossier/*")
public class PatientDossierServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Afficher le dossier médical du patient
            afficherDossierMedical(request, response);
        } else if (pathInfo.equals("/telecharger")) {
            // Télécharger un document médical
            telechargerDocument(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/dossier");
        }
    }
    
    private void afficherDossierMedical(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
        
        Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }
        
        DossierMedical dossier = dossierMedicalDAO.findByPatient(patient.getId());
        
        request.setAttribute("patient", patient);
        request.setAttribute("dossier", dossier);
        request.getRequestDispatcher("/views/patient/dossier.jsp").forward(request, response);
    }
    
    private void telechargerDocument(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int documentId = Integer.parseInt(request.getParameter("id"));
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
            
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
            
            DossierMedical dossier = dossierMedicalDAO.findByPatient(patient.getId());
            if (dossier == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dossier");
                return;
            }
            
            DocumentMedical document = dossier.getDocuments().stream()
                .filter(d -> d.getId() == documentId)
                .findFirst()
                .orElse(null);
            
            if (document == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dossier");
                return;
            }
            
            File file = new File(document.getCheminFichier());
            if (!file.exists()) {
                response.sendRedirect(request.getContextPath() + "/patient/dossier");
                return;
            }
            
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + document.getNom() + "\"");
            
            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/dossier");
        }
    }
} 