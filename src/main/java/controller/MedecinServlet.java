package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.MedecinDAO;
import dao.UtilisateurDAO;
import dao.SpecialiteDAO;
import model.Medecin;
import model.Utilisateur;
import model.Specialite;
import java.util.List;

@WebServlet("/medecin/*")
public class MedecinServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public MedecinServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            // Liste des médecins
            afficherListeMedecins(request, response);
        } else if (pathInfo.equals("/ajouter")) {
            // Formulaire d'ajout
            afficherFormulaireAjout(request, response);
        } else if (pathInfo.equals("/modifier")) {
            // Formulaire de modification
            afficherFormulaireModification(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/medecin");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        MedecinDAO medecinDAO = new MedecinDAO();
        UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
        SpecialiteDAO specialiteDAO = new SpecialiteDAO();

        String idStr = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String specialiteNom = request.getParameter("specialite");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        Medecin medecin;
        Utilisateur utilisateur;
        Specialite specialite = specialiteDAO.findByNom(specialiteNom);

        if (idStr == null || idStr.isEmpty()) {
            // Create new Medecin and associated Utilisateur
            utilisateur = new Utilisateur();
            utilisateur.setNom(nom);
            utilisateur.setPrenom(prenom);
            utilisateur.setEmail(email);
            utilisateur.setMotDePasse(motDePasse != null ? motDePasse : "");
            utilisateur.setRole("medecin");
            utilisateurDAO.save(utilisateur);

            medecin = new Medecin();
            medecin.setUtilisateur(utilisateur);
            medecin.setSpecialite(specialite);

            medecinDAO.save(medecin);
        } else {
            // Update existing Medecin and associated Utilisateur
            medecin = medecinDAO.findById(Integer.parseInt(idStr));
            if (medecin != null) {
                utilisateur = medecin.getUtilisateur();
                if (utilisateur != null) {
                    utilisateur.setNom(nom);
                    utilisateur.setPrenom(prenom);
                    utilisateur.setEmail(email);
                    if (motDePasse != null && !motDePasse.isEmpty()) {
                        utilisateur.setMotDePasse(motDePasse);
                    }
                    utilisateurDAO.update(utilisateur);
                }
                medecin.setSpecialite(specialite);
                medecinDAO.update(medecin);
            }
        }
        response.sendRedirect(request.getContextPath() + "/medecin");
    }

    private void afficherListeMedecins(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MedecinDAO medecinDAO = new MedecinDAO();
        List<Medecin> medecins = medecinDAO.findAll();
        request.setAttribute("medecins", medecins);
        request.getRequestDispatcher("/views/medecin/liste.jsp").forward(request, response);
    }

    private void afficherFormulaireAjout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SpecialiteDAO specialiteDAO = new SpecialiteDAO();
        List<Specialite> specialites = specialiteDAO.findAll();
        request.setAttribute("specialites", specialites);
        request.getRequestDispatcher("/views/medecin/formulaire.jsp").forward(request, response);
    }

    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            MedecinDAO medecinDAO = new MedecinDAO();
            Medecin medecin = medecinDAO.findById(Integer.parseInt(idStr));
            if (medecin != null) {
                SpecialiteDAO specialiteDAO = new SpecialiteDAO();
                List<Specialite> specialites = specialiteDAO.findAll();
                request.setAttribute("medecin", medecin);
                request.setAttribute("specialites", specialites);
                request.getRequestDispatcher("/views/medecin/formulaire.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/medecin");
    }
} 