package controller;

import java.io.IOException;
import java.util.Date;

import dao.DoctorDAO;
import dao.PatientDAO;
import dao.SpecialtyDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Doctor;
import model.Patient;
import model.Specialty;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
@SuppressWarnings("serial")
public class RegisterServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Pour afficher la liste des spécialités dans le formulaire d'inscription des médecins
        SpecialtyDAO specialiteDAO = new SpecialtyDAO();
        request.setAttribute("specialites", specialiteDAO.findAll());
        
        // Forward to the registration form
        request.getRequestDispatcher("views/register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Récupération des paramètres du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String confirmerMotDePasse = request.getParameter("confirmerMotDePasse");
        String role = request.getParameter("role");
        
        // Validation des données
        if (nom == null || nom.trim().isEmpty() ||
            prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        if (!motDePasse.equals(confirmerMotDePasse)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas.");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }
        
        UserDAO utilisateurDAO = new UserDAO();

        // Vérifier si l'email existe déjà
        if (utilisateurDAO.findByEmail(email) != null) {
            request.setAttribute("error", "Cet email est déjà utilisé.");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        try {
            // Création de l'utilisateur
            User utilisateur = new User();
            utilisateur.setNom(nom);
            utilisateur.setPrenom(prenom);
            utilisateur.setEmail(email);
            utilisateur.setMotDePasse(motDePasse); // Dans un cas réel, il faudrait hasher le mot de passe
            utilisateur.setRole(role);
            utilisateur.setDateInscription(new Date());
            
            // Sauvegarde de l'utilisateur
            utilisateurDAO.save(utilisateur);
            
            // Création du profil spécifique selon le rôle
            if ("medecin".equals(role)) {
                // Validation des champs spécifiques au médecin
                String specialiteId = request.getParameter("specialite");
                String numeroOrdre = request.getParameter("numeroOrdre");
                String anneesExperience = request.getParameter("anneesExperience");
                
                if (specialiteId == null || numeroOrdre == null || numeroOrdre.trim().isEmpty()) {
                    request.setAttribute("error", "Tous les champs obligatoires du médecin doivent être remplis.");
                    request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                    return;
                }
                
                Doctor medecin = new Doctor();
                medecin.setUtilisateur(utilisateur);

                // Récupération de la spécialité
                SpecialtyDAO specialiteDAO = new SpecialtyDAO();
                Specialty specialite = specialiteDAO.findById(Integer.parseInt(specialiteId));
                if (specialite == null) {
                    request.setAttribute("error", "Spécialité invalide.");
                    request.getRequestDispatcher("/views/register.jsp").forward(request, response);
                    return;
                }
                medecin.setSpecialite(specialite);
                
                // Configuration des autres champs
                medecin.setNumeroOrdre(numeroOrdre);
                if (anneesExperience != null && !anneesExperience.trim().isEmpty()) {
                    medecin.setAnneesExperience(Integer.parseInt(anneesExperience));
                }
                
                DoctorDAO medecinDAO = new DoctorDAO();
                medecinDAO.save(medecin);
            } else if ("patient".equals(role)) {
                Patient patient = new Patient();
                patient.setUtilisateur(utilisateur);
                PatientDAO patientDAO = new PatientDAO();
                patientDAO.save(patient);
            }
            
            // Redirection vers la page de connexion avec un message de succès
            HttpSession session = request.getSession();
            session.setAttribute("message", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            
        } catch (Exception e) {
            e.printStackTrace(); // Add this for debugging
            request.setAttribute("error", "Une erreur est survenue lors de l'inscription. Veuillez réessayer.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}