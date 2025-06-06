package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import dao.RendezVousDAO;
import dao.MedecinDAO;
import dao.PatientDAO;
import model.RendezVous;
import model.Utilisateur;

@WebServlet("/admin/rendez-vous/*")
public class AdminRendezVousServlet extends HttpServlet {
    private RendezVousDAO rendezVousDAO;
    private MedecinDAO medecinDAO;
    private PatientDAO patientDAO;
    
    @Override
    public void init() throws ServletException {
        rendezVousDAO = new RendezVousDAO();
        medecinDAO = new MedecinDAO();
        patientDAO = new PatientDAO();
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
        
        // Get all appointments
        List<RendezVous> rendezVous = rendezVousDAO.findAll();
        request.setAttribute("rendezVous", rendezVous);
        
        // Get all doctors and patients for the form
        request.setAttribute("medecins", medecinDAO.findAll());
        request.setAttribute("patients", patientDAO.findAll());
        
        request.getRequestDispatcher("/views/admin/rendez_vous.jsp")
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
        
        String action = request.getParameter("action");
        
        try {
            if ("ajouter".equals(action)) {
                // Create new appointment
                RendezVous rendezVous = new RendezVous();
                rendezVous.setMedecin(medecinDAO.findById(Integer.parseInt(request.getParameter("medecinId"))));
                rendezVous.setPatient(patientDAO.findById(Integer.parseInt(request.getParameter("patientId"))));
                
                // Combine date and time into a single Date object
                String dateStr = request.getParameter("date");
                String timeStr = request.getParameter("heure");
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Date dateHeure = dateFormat.parse(dateStr + " " + timeStr);
                rendezVous.setDateHeure(dateHeure);
                
                rendezVous.setStatut("planifié");
                
                rendezVousDAO.save(rendezVous);
            } else if ("modifier".equals(action)) {
                // Update appointment
                RendezVous rendezVous = rendezVousDAO.findById(Integer.parseInt(request.getParameter("id")));
                if (rendezVous != null) {
                    rendezVous.setMedecin(medecinDAO.findById(Integer.parseInt(request.getParameter("medecinId"))));
                    rendezVous.setPatient(patientDAO.findById(Integer.parseInt(request.getParameter("patientId"))));
                    
                    // Combine date and time into a single Date object
                    String dateStr = request.getParameter("date");
                    String timeStr = request.getParameter("heure");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    Date dateHeure = dateFormat.parse(dateStr + " " + timeStr);
                    rendezVous.setDateHeure(dateHeure);
                    
                    rendezVous.setStatut(request.getParameter("statut"));
                    
                    rendezVousDAO.update(rendezVous);
                }
            } else if ("supprimer".equals(action)) {
                // Delete appointment
            	RendezVous rendezVous = rendezVousDAO.findById(Integer.parseInt(request.getParameter("id")));
                rendezVousDAO.delete(rendezVous);
            }
        } catch (ParseException e) {
            // Handle date parsing error
            request.setAttribute("error", "Format de date invalide");
            doGet(request, response);
            return;
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/rendez-vous");
    }
} 