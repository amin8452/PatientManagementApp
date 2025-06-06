<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rendez-vous</title>
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

        .search-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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

        .search-input {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
        }

        .search-input:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .appointment-card {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .appointment-info i {
            color: var(--secondary-color);
            margin-right: 10px;
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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <h3 class="mb-4">Dr. ${sessionScope.utilisateur.nom}</h3>
                <nav class="nav flex-column">
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/medecin/rendez-vous">
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
                <!-- Page Header -->
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-0">Rendez-vous</h2>
                        <p class="mb-0">Gérez vos rendez-vous</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medecin/rendez-vous/nouveau" class="btn btn-light">
                        <i class="fas fa-calendar-plus me-2"></i>Nouveau Rendez-vous
                    </a>
                </div>

                <!-- Search and Filter -->
                <div class="search-card">
                    <form action="${pageContext.request.contextPath}/medecin/rendez-vous" method="get" class="row g-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control search-input" name="search" 
                                       placeholder="Rechercher un patient..." value="${param.search}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="">Tous les statuts</option>
                                <option value="en attente" ${param.status eq 'en attente' ? 'selected' : ''}>En attente</option>
                                <option value="accepté" ${param.status eq 'accepté' ? 'selected' : ''}>Accepté</option>
                                <option value="annulé" ${param.status eq 'annulé' ? 'selected' : ''}>Annulé</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="date" class="form-control" name="date" value="${param.date}">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn action-button w-100">
                                <i class="fas fa-filter me-2"></i>Filtrer
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Calendar View -->
                <div class="calendar-view mb-4">
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

                <!-- Appointments Table -->
                <div class="appointments-table">
                    <c:if test="${empty rendezVousList}">
                        <div class="empty-state">
                            <i class="fas fa-calendar-times"></i>
                            <h4>Aucun rendez-vous</h4>
                            <p>Vous n'avez aucun rendez-vous pour le moment.</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty rendezVousList}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Date et heure</th>
                                        <th>Patient</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${rendezVousList}" var="rendezVous">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${rendezVous.dateHeure}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>${rendezVous.patient.utilisateur.nom} ${rendezVous.patient.utilisateur.prenom}</td>
                                            <td>
                                                <span class="status-badge status-${rendezVous.statut == 'en attente' ? 'pending' : (rendezVous.statut == 'accepté' ? 'confirmed' : 'cancelled')}">
                                                    ${rendezVous.statut}
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${rendezVous.statut == 'en attente'}">
                                                    <a href="${pageContext.request.contextPath}/medecin/rendez-vous/accepter?id=${rendezVous.id}" class="btn btn-success btn-sm">
                                                        <i class="fas fa-check"></i> Accepter
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/medecin/rendez-vous/refuser?id=${rendezVous.id}" class="btn btn-danger btn-sm">
                                                        <i class="fas fa-times"></i> Refuser
                                                    </a>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/medecin/rendez-vous/detail?id=${rendezVous.id}" class="btn btn-info btn-sm">
                                                    <i class="fas fa-eye"></i> Détails
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 