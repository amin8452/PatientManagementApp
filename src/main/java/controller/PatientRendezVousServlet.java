package controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import dao.MedecinDAO;
import dao.PatientDAO;
import dao.RendezVousDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Medecin;
import model.Patient;
import model.RendezVous;
import model.Utilisateur;

@WebServlet("/patient/rendez-vous/*")
public class PatientRendezVousServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private RendezVousDAO rendezVousDAO = new RendezVousDAO();
    private MedecinDAO medecinDAO = new MedecinDAO();
    
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
            // Afficher la liste des rendez-vous
            afficherListeRendezVous(request, response);
        } else if (pathInfo.equals("/nouveau")) {
            // Afficher le formulaire de nouveau rendez-vous
            request.setAttribute("medecins", medecinDAO.findAll());
            request.getRequestDispatcher("/views/patient/nouveau-rendez-vous.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/rendez-vous");
        }
    }
    
    private void afficherListeRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
        
        Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }
        
        List<RendezVous> rendezVousList = rendezVousDAO.findByPatient(patient.getId());
        request.setAttribute("rendezVousList", rendezVousList);
        request.getRequestDispatcher("/views/patient/rendez-vous.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/nouveau")) {
            // Enregistrement d'un nouveau rendez-vous
            enregistrerNouveauRendezVous(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/patient/rendez-vous");
        }
    }
    
    private void enregistrerNouveauRendezVous(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Utilisateur utilisateur = (Utilisateur) request.getSession().getAttribute("utilisateur");
            Patient patient = patientDAO.findByUtilisateur(utilisateur.getId());
            
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/patient/dashboard");
                return;
            }
            
            int medecinId = Integer.parseInt(request.getParameter("medecinId"));
            String dateStr = request.getParameter("date");
            String heureStr = request.getParameter("heure");
            
            Medecin medecin = medecinDAO.findById(medecinId);
            if (medecin == null) {
                response.sendRedirect(request.getContextPath() + "/patient/rendez-vous/nouveau");
                return;
            }
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date dateHeure = dateFormat.parse(dateStr + " " + heureStr);
            
            RendezVous rendezVous = new RendezVous();
            rendezVous.setPatient(patient);
            rendezVous.setMedecin(medecin);
            rendezVous.setDateHeure(dateHeure);
            rendezVous.setStatut("en attente");
            
            rendezVousDAO.save(rendezVous);
            response.sendRedirect(request.getContextPath() + "/patient/rendez-vous");
            
        } catch (ParseException | NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patient/rendez-vous/nouveau");
        }
    }
}