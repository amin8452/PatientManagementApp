<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
             --primary-color: #000000;
            --secondary-color: #182b53;
            --accent-color: #87291f;
            --light-bg: #f8f9fa;
            --dark-bg: #343a40;
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .sidebar {
            background-color: var(--primary-color);
            min-height: 100vh;
            padding: 20px;
            color: white;
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 10px 15px;
            margin: 5px 0;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .sidebar .nav-link:hover {
            background-color: var(--secondary-color);
            color: white;
        }

        .sidebar .nav-link.active {
            background-color: var(--secondary-color);
            color: white;
        }

        .main-content {
            padding: 20px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
            color: var(--secondary-color);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .stat-label {
            color: #6c757d;
            font-size: 1.1rem;
        }

        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .quick-actions {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .action-button {
            background-color: var(--secondary-color);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .action-button:hover {
            background-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .appointment-card {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .appointment-time {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .appointment-patient {
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <h3 class="mb-4">Dr. ${sessionScope.utilisateur.nom}</h3>
                <nav class="nav flex-column">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/medecin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/patients">
                        <i class="fas fa-users me-2"></i>Patients
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/dossiers">
                        <i class="fas fa-folder me-2"></i>Dossiers médicaux
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <h2>Bienvenue, Dr. ${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}</h2>
                    <p class="mb-0">Voici un aperçu de votre activité médicale</p>
                </div>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="stat-value">${nombreRendezVousAujourdhui}</div>
                            <div class="stat-label">Rendez-vous aujourd'hui</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-value">${nombrePatients}</div>
                            <div class="stat-label">Patients</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-file-medical"></i>
                            </div>
                            <div class="stat-value">${nombreDossiers}</div>
                            <div class="stat-label">Dossiers médicaux</div>
                        </div>
                    </div>
                </div>

                <!-- Today's Appointments -->
                <div class="quick-actions">
                    <h4 class="mb-4">Rendez-vous du jour</h4>
                    <c:choose>
                        <c:when test="${empty rendezVousAujourdhui}">
                            <p class="text-muted">Aucun rendez-vous aujourd'hui.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${rendezVousAujourdhui}" var="rdv">
                                <div class="appointment-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <div class="appointment-time">
                                                <i class="fas fa-clock me-2"></i>
                                                <fmt:formatDate value="${rdv.dateHeure}" pattern="HH:mm"/>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="appointment-patient">
                                                <i class="fas fa-user me-2"></i>
                                                ${rdv.patient.utilisateur.nom} ${rdv.patient.utilisateur.prenom}
                                            </div>
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <a href="${pageContext.request.contextPath}/medecin/rendez-vous/${rdv.id}" 
                                               class="btn btn-sm action-button">
                                                <i class="fas fa-eye me-2"></i>Voir détails
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Quick Actions -->
                 <div class="quick-actions">
    <h4 class="mb-4">Actions rapides</h4>
    <div class="row g-3">
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/medecin/rendez-vous/nouveau" class="btn action-button w-100 py-3 d-flex align-items-center justify-content-center">
                <i class="fas fa-calendar-plus fa-lg me-3"></i>
                <span class="fw-bold">Prendre un rendez-vous</span>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/medecin/dossiers/nouveau" class="btn action-button w-100 py-3 d-flex align-items-center justify-content-center">
                <i class="fas fa-file-medical fa-lg me-3"></i>
                <span class="fw-bold">Créer un dossier médical</span>
            </a>
        </div>
        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/medecin/patients" class="btn action-button w-100 py-3 d-flex align-items-center justify-content-center">
                <i class="fas fa-user-plus fa-lg me-3"></i>
                <span class="fw-bold">Ajouter un patient</span>
            </a>
        </div>
    </div>
</div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>