package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.RendezVousDAO;
import model.RendezVous;
import java.util.List;
import model.Patient;
import model.Medecin;
import dao.PatientDAO;
import dao.MedecinDAO;
import java.text.SimpleDateFormat;
import java.text.ParseException;

/**
 * Servlet implementation class RendezVousServlet
 */
@WebServlet("/RendezVousServlet")
public class RendezVousServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RendezVousServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		RendezVousDAO rendezVousDAO = new RendezVousDAO();
		if (action == null) action = "list";
		switch (action) {
			case "new":
				request.getRequestDispatcher("/WEB-INF/views/rendezVousForm.jsp").forward(request, response);
				break;
			case "edit":
				int idEdit = Integer.parseInt(request.getParameter("id"));
				RendezVous rendezVousEdit = rendezVousDAO.findById(idEdit);
				request.setAttribute("rendezVous", rendezVousEdit);
				request.getRequestDispatcher("/WEB-INF/views/rendezVousForm.jsp").forward(request, response);
				break;
			case "delete":
				int idDelete = Integer.parseInt(request.getParameter("id"));
				RendezVous rendezVousDelete = rendezVousDAO.findById(idDelete);
				if (rendezVousDelete != null) rendezVousDAO.delete(rendezVousDelete);
				response.sendRedirect("RendezVousServlet");
				break;
			default:
				List<RendezVous> rendezVousList = rendezVousDAO.findAll();
				request.setAttribute("rendezVousList", rendezVousList);
				request.getRequestDispatcher("/WEB-INF/views/rendezVousList.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		RendezVousDAO rendezVousDAO = new RendezVousDAO();
		PatientDAO patientDAO = new PatientDAO();
		MedecinDAO medecinDAO = new MedecinDAO();
		String idStr = request.getParameter("id");
		String date = request.getParameter("date");
		String heure = request.getParameter("heure");
		String patientId = request.getParameter("patientId");
		String medecinId = request.getParameter("medecinId");
		RendezVous rendezVous = new RendezVous();
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			if(date != null && heure != null) {
				rendezVous.setDateHeure(sdf.parse(date + " " + heure));
			}
		} catch (ParseException e) {
			throw new ServletException("Erreur de format de date/heure", e);
		}
		if(patientId != null && !patientId.isEmpty()) {
			Patient patient = patientDAO.findById(Integer.parseInt(patientId));
			rendezVous.setPatient(patient);
		}
		if(medecinId != null && !medecinId.isEmpty()) {
			Medecin medecin = medecinDAO.findById(Integer.parseInt(medecinId));
			rendezVous.setMedecin(medecin);
		}
		if (idStr == null || idStr.isEmpty()) {
			rendezVousDAO.save(rendezVous);
		} else {
			rendezVous.setId(Integer.parseInt(idStr));
			rendezVousDAO.update(rendezVous);
		}
		response.sendRedirect("RendezVousServlet");
	}

}
