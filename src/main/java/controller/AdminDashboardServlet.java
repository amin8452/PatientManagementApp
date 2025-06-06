package controller;

import dao.MedecinDAO;
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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private MedecinDAO medecinDAO = new MedecinDAO();
    private PatientDAO patientDAO = new PatientDAO();
    private RendezVousDAO rendezVousDAO = new RendezVousDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        // Get total number of doctors
        request.setAttribute("nombreMedecins", medecinDAO.count());

        // Get total number of patients
        request.setAttribute("nombrePatients", patientDAO.count());

        // Get total number of appointments
        request.setAttribute("nombreRendezVous", rendezVousDAO.count());

        // Forward to dashboard JSP
        request.getRequestDispatcher("/views/admin/dashboard.jsp")
               .forward(request, response);
    }
} 