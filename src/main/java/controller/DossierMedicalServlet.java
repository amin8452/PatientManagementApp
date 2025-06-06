package controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import dao.DossierMedicalDAO;
import dao.MedecinDAO;
import dao.PatientDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.DocumentMedical;
import model.DossierMedical;
import model.Medecin;
import model.Patient;
import model.Utilisateur;

@WebServlet("/medecin/dossiers/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class DossierMedicalServlet extends HttpServlet {
    
    private static final String UPLOAD_DIRECTORY = "uploads/documents";
    
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
            // Liste des dossiers médicaux du médecin
            afficherListeDossiers(request, response);
        } else if (pathInfo.equals("/patient")) {
            // Afficher ou créer le dossier médical d'un patient
            afficherDossierPatient(request, response);
        } else if (pathInfo.equals("/telecharger")) {
            // Télécharger un document médical
            telechargerDocument(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        } else if (pathInfo.equals("/patient")) {
            // Mettre à jour ou créer le dossier médical d'un patient
            mettreAJourDossierPatient(request, response);
        } else if (pathInfo.equals("/ajouter-document")) {
            // Ajouter un document au dossier médical
            ajouterDocument(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    private void afficherListeDossiers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
        
        MedecinDAO medecinDAO = new MedecinDAO();
        Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
        
        DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
        List<DossierMedical> dossiers = dossierMedicalDAO.findByMedecin(medecin.getId());
        
        request.setAttribute("dossiers", dossiers);
        request.getRequestDispatcher("/views/medecin/dossiers.jsp").forward(request, response);
    }
    
    private void afficherDossierPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("id"));
            
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.findById(patientId);
            
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
                return;
            }
            
            DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
            DossierMedical dossier = dossierMedicalDAO.findByPatient(patientId);
            
            // Si le dossier n'existe pas, préparer la création d'un nouveau dossier
            if (dossier == null) {
                request.setAttribute("nouveauDossier", true);
            }
            
            request.setAttribute("patient", patient);
            request.setAttribute("dossier", dossier);
            request.getRequestDispatcher("/views/medecin/dossier-patient.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    private void mettreAJourDossierPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            
            PatientDAO patientDAO = new PatientDAO();
            Patient patient = patientDAO.findById(patientId);
            
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
                return;
            }
            
            // Récupérer le médecin connecté
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            MedecinDAO medecinDAO = new MedecinDAO();
            Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
            
            // Récupérer les données du formulaire
            String antecedents = request.getParameter("antecedents");
            String traitements = request.getParameter("traitements");
            String examens = request.getParameter("examens");
            
            DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
            DossierMedical dossier = dossierMedicalDAO.findByPatient(patientId);
            
            // Si le dossier n'existe pas, créer un nouveau dossier
            if (dossier == null) {
                dossier = new DossierMedical();
                dossier.setPatient(patient);
                dossier.setMedecin(medecin);
            }
            
            dossier.setAntecedents(antecedents);
            dossier.setTraitements(traitements);
            dossier.setExamens(examens);
            
            // Sauvegarder ou mettre à jour le dossier
            if (dossier.getId() == 0) {
                dossierMedicalDAO.save(dossier);
            } else {
                dossierMedicalDAO.update(dossier);
            }
            
            request.getSession().setAttribute("message", "Le dossier médical a été mis à jour avec succès.");
            request.getSession().setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers/patient?id=" + patientId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    private void ajouterDocument(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int dossierId = Integer.parseInt(request.getParameter("dossierId"));
            
            DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
            DossierMedical dossier = dossierMedicalDAO.findById(dossierId);
            
            if (dossier == null) {
                response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
                return;
            }
            
            // Récupérer le fichier téléchargé
            Part filePart = request.getPart("document");
            String fileName = getSubmittedFileName(filePart);
            
            if (fileName != null && !fileName.isEmpty()) {
                // Générer un nom de fichier unique pour éviter les conflits
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                
                // Créer le répertoire d'upload s'il n'existe pas
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Sauvegarder le fichier
                String filePath = uploadPath + File.separator + uniqueFileName;
                try (InputStream input = filePart.getInputStream();
                     FileOutputStream output = new FileOutputStream(filePath)) {
                    
                    byte[] buffer = new byte[1024];
                    int length;
                    while ((length = input.read(buffer)) > 0) {
                        output.write(buffer, 0, length);
                    }
                }
                
                // Créer et sauvegarder le document médical
                DocumentMedical document = new DocumentMedical();
                document.setNom(fileName);
                document.setCheminFichier(UPLOAD_DIRECTORY + "/" + uniqueFileName);
                document.setDossierMedical(dossier);
                
                dossierMedicalDAO.addDocument(document);
                
                request.getSession().setAttribute("message", "Le document a été ajouté avec succès.");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Aucun fichier n'a été sélectionné.");
                request.getSession().setAttribute("messageType", "danger");
            }
            
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers/patient?id=" + dossier.getPatient().getId());
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    private void telechargerDocument(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int documentId = Integer.parseInt(request.getParameter("id"));
            
            DossierMedicalDAO dossierMedicalDAO = new DossierMedicalDAO();
            DocumentMedical document = dossierMedicalDAO.findDocumentById(documentId);
            
            if (document != null) {
                // Vérifier que le document appartient bien au médecin connecté
                Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
                MedecinDAO medecinDAO = new MedecinDAO();
                Medecin medecin = medecinDAO.findByUtilisateur(utilisateur.getId());
                
                if (document.getDossierMedical().getMedecin().getId() == medecin.getId()) {
                    String filePath = getServletContext().getRealPath("") + File.separator + document.getCheminFichier();
                    File file = new File(filePath);
                    
                    if (file.exists()) {
                        response.setContentType("application/octet-stream");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + document.getNom() + "\"");
                        
                        try (FileInputStream in = new FileInputStream(file);
                             OutputStream out = response.getOutputStream()) {
                            
                            byte[] buffer = new byte[4096];
                            int length;
                            while ((length = in.read(buffer)) > 0) {
                                out.write(buffer, 0, length);
                            }
                        }
                        return;
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/medecin/dossiers");
        }
    }
    
    // Méthode utilitaire pour extraire le nom du fichier de la partie multipart
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
} 