package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.PatientDAO;
import model.Patient;
import java.util.List;
import dao.UtilisateurDAO;
import model.Utilisateur;

/**
 * Servlet implementation class PatientServlet
 */
@WebServlet("/medecin/patients/*")
public class PatientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private PatientDAO patientDAO;
	private UtilisateurDAO utilisateurDAO;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PatientServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	public void init() throws ServletException {
		patientDAO = new PatientDAO();
		utilisateurDAO = new UtilisateurDAO();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		if (pathInfo == null || pathInfo.equals("/")) {
			// Liste des patients
			List<Patient> patients = patientDAO.findAll();
			request.setAttribute("patients", patients);
			request.getRequestDispatcher("/views/medecin/patients.jsp").forward(request, response);
		} else if (pathInfo.equals("/nouveau")) {
			// Formulaire de nouveau patient
			request.getRequestDispatcher("/views/medecin/nouveau-patient.jsp").forward(request, response);
		} else if (pathInfo.equals("/modifier")) {
			// Formulaire de modification
			int id = Integer.parseInt(request.getParameter("id"));
			Patient patient = patientDAO.findById(id);
			request.setAttribute("patient", patient);
			request.getRequestDispatcher("/views/medecin/modifier-patient.jsp").forward(request, response);
		} else if (pathInfo.equals("/supprimer")) {
			// Suppression d'un patient
			int id = Integer.parseInt(request.getParameter("id"));
			Patient patient = patientDAO.findById(id);
			if (patient != null) {
				patientDAO.delete(patient);
			}
			response.sendRedirect(request.getContextPath() + "/medecin/patients");
		} else {
			response.sendRedirect(request.getContextPath() + "/medecin/patients");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String pathInfo = request.getPathInfo();
		
		if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/nouveau")) {
			// Création d'un nouveau patient
			String nom = request.getParameter("nom");
			String prenom = request.getParameter("prenom");
			String email = request.getParameter("email");
			String motDePasse = request.getParameter("motDePasse");
			
			Utilisateur utilisateur = new Utilisateur();
			utilisateur.setNom(nom);
			utilisateur.setPrenom(prenom);
			utilisateur.setEmail(email);
			utilisateur.setMotDePasse(motDePasse);
			utilisateur.setRole("patient");
			utilisateurDAO.save(utilisateur);
			
			Patient patient = new Patient();
			patient.setUtilisateur(utilisateur);
			patientDAO.save(patient);
			
			response.sendRedirect(request.getContextPath() + "/medecin/patients");
		} else if (pathInfo.equals("/modifier")) {
			// Modification d'un patient
			int id = Integer.parseInt(request.getParameter("id"));
			Patient patient = patientDAO.findById(id);
			
			if (patient != null) {
				Utilisateur utilisateur = patient.getUtilisateur();
				utilisateur.setNom(request.getParameter("nom"));
				utilisateur.setPrenom(request.getParameter("prenom"));
				utilisateur.setEmail(request.getParameter("email"));
				
				String motDePasse = request.getParameter("motDePasse");
				if (motDePasse != null && !motDePasse.isEmpty()) {
					utilisateur.setMotDePasse(motDePasse);
				}
				
				utilisateurDAO.update(utilisateur);
				patientDAO.update(patient);
			}
			
			response.sendRedirect(request.getContextPath() + "/medecin/patients");
		} else {
			response.sendRedirect(request.getContextPath() + "/medecin/patients");
		}
	}

}
