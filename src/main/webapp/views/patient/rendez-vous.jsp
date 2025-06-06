<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous</title>
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

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .appointments-table {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            color: var(--primary-color);
            font-weight: 600;
            border-bottom: 2px solid var(--light-bg);
        }

        .table td {
            vertical-align: middle;
        }

        .action-button {
            background-color: var(--secondary-color);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .action-button:hover {
            background-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }

        .status-confirmed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .calendar-view {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
        }

        .calendar-day {
            aspect-ratio: 1;
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .calendar-day:hover {
            background-color: var(--light-bg);
        }

        .calendar-day.has-appointments {
            background-color: rgba(52, 152, 219, 0.1);
            border-color: var(--secondary-color);
        }

        .calendar-day.today {
            background-color: var(--secondary-color);
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }

        .empty-state i {
            font-size: 48px;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <h3 class="mb-4">${sessionScope.utilisateur.nom}</h3>
                <nav class="nav flex-column">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dossier">
                        <i class="fas fa-folder me-2"></i>Mon dossier
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/profile">
                        <i class="fas fa-user me-2"></i>Mon profil
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Page Header -->
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-0">Mes Rendez-vous</h2>
                        <p class="mb-0">Gérez vos rendez-vous médicaux</p>
                    </div>
                    <div class="text-end">
                        <a href="${pageContext.request.contextPath}/patient/rendez-vous/nouveau" class="btn action-button">
                            <i class="fas fa-plus me-2"></i>Nouveau rendez-vous
                        </a>
                    </div>
                </div>

                <!-- Calendar View -->
                <div class="calendar-view">
                    <div class="calendar-header">
                        <h5 class="mb-0">Calendrier des rendez-vous</h5>
                        <div class="btn-group">
                            <button class="btn btn-outline-secondary">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button class="btn btn-outline-secondary">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="calendar-grid">
                        <!-- Calendar days will be dynamically populated -->
                    </div>
                </div>

                <!-- Appointments List -->
                <div class="appointments-table">
                    <c:choose>
                        <c:when test="${empty rendezVous}">
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h4>Aucun rendez-vous trouvé</h4>
                                <p class="text-muted">Planifiez votre premier rendez-vous</p>
                                <a href="${pageContext.request.contextPath}/patient/rendez-vous/nouveau" class="btn action-button">
                                    <i class="fas fa-calendar-plus me-2"></i>Planifier un rendez-vous
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Date et heure</th>
                                            <th>Médecin</th>
                                            <th>Type</th>
                                            <th>Statut</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${rendezVous}" var="rdv">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-clock text-secondary me-3"></i>
                                                        <div>
                                                            <div class="fw-bold">
                                                                <fmt:formatDate value="${rdv.dateHeure}" pattern="dd/MM/yyyy"/>
                                                            </div>
                                                            <small class="text-muted">
                                                                <fmt:formatDate value="${rdv.dateHeure}" pattern="HH:mm"/>
                                                            </small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-user-md text-secondary me-3"></i>
                                                        <div>
                                                            <div class="fw-bold">Dr. ${rdv.medecin.utilisateur.nom}</div>
                                                            <small class="text-muted">${rdv.medecin.specialite.nom}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${rdv.typeConsultation}</td>
                                                <td>
                                                    <span class="status-badge ${rdv.statut eq 'en attente' ? 'status-pending' : 
                                                                          rdv.statut eq 'accepté' ? 'status-confirmed' : 
                                                                          'status-cancelled'}">
                                                        ${rdv.statut}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="${pageContext.request.contextPath}/patient/rendez-vous/${rdv.id}" 
                                                           class="btn btn-sm action-button me-2">
                                                            <i class="fas fa-eye me-1"></i>Détails
                                                        </a>
                                                        <c:if test="${rdv.statut eq 'en attente'}">
                                                            <a href="${pageContext.request.contextPath}/patient/rendez-vous/${rdv.id}/annuler" 
                                                               class="btn btn-sm btn-danger">
                                                                <i class="fas fa-times me-1"></i>Annuler
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 