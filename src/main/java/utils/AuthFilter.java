package utils;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Utilisateur;

@WebFilter(urlPatterns = {"/admin/*", "/medecin/*", "/patient/*", "/profil"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Allow access to static resources and login/register pages
        if (path.startsWith("/css/") || 
            path.startsWith("/js/") || 
            path.startsWith("/images/") ||
            path.equals("/views/login.jsp") ||
            path.equals("/views/register.jsp") ||
            path.equals("/login") ||
            path.equals("/register")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if the user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("utilisateur") != null);
        
        if (!isLoggedIn) {
            httpResponse.sendRedirect(contextPath + "/views/login.jsp");
            return;
        }
        
        // User is logged in, check role-based access
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        String role = utilisateur.getRole();
        
        if (path.startsWith("/admin/") && !"admin".equals(role)) {
            httpResponse.sendRedirect(contextPath + "/views/error/403.jsp");
            return;
        } else if (path.startsWith("/medecin/") && !"medecin".equals(role)) {
            httpResponse.sendRedirect(contextPath + "/views/error/403.jsp");
            return;
        } else if (path.startsWith("/patient/") && !"patient".equals(role)) {
            httpResponse.sendRedirect(contextPath + "/views/error/403.jsp");
            return;
        }
        
        // User has appropriate access, continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code
    }
} 