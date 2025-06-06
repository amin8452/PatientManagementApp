package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import dao.UtilisateurDAO;
import model.Utilisateur;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class AdminServlet
 */
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UtilisateurDAO utilisateurDAO;
       
    @Override
    public void init() throws ServletException {
        utilisateurDAO = new UtilisateurDAO();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		HttpSession session = request.getSession();
		Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

		if (user == null || !"admin".equals(user.getRole())) {
			response.sendRedirect(request.getContextPath() + "/views/login.jsp");
			return;
		}

		if (pathInfo == null || pathInfo.equals("/")) {
			// Default to dashboard
			response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			return;
		}

		switch (pathInfo) {
			case "/dashboard":
				request.getRequestDispatcher("/views/admin/dashboard.jsp")
					   .forward(request, response);
				break;
			case "/statistiques":
				request.getRequestDispatcher("/views/admin/statistiques.jsp")
					   .forward(request, response);
				break;
			case "/gestion-utilisateurs":
				request.getRequestDispatcher("/views/admin/gestion_utilisateurs.jsp")
					   .forward(request, response);
				break;
			default:
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				break;
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		HttpSession session = request.getSession();
		Utilisateur user = (Utilisateur) session.getAttribute("utilisateur");

		if (user == null || !"admin".equals(user.getRole())) {
			response.sendRedirect(request.getContextPath() + "/views/login.jsp");
			return;
		}

		if (pathInfo == null || pathInfo.equals("/")) {
			response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			return;
		}

		switch (pathInfo) {
			case "/logout":
				session.invalidate();
				response.sendRedirect(request.getContextPath() + "/views/login.jsp");
				break;
			default:
				response.sendError(HttpServletResponse.SC_NOT_FOUND);
				break;
		}
	}

}
