<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dossiers Médicaux</title>
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

        .search-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .patient-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .patient-card:hover {
            transform: translateY(-2px);
        }

        .patient-info {
            margin-bottom: 15px;
        }

        .patient-info i {
            color: var(--secondary-color);
            margin-right: 10px;
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

        .last-visit {
            font-size: 0.9rem;
            color: var(--secondary-color);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/patients">
                        <i class="fas fa-users me-2"></i>Patients
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/medecin/dossiers">
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
                <div class="page-header">
                    <h2 class="mb-0">Dossiers Médicaux</h2>
                    <p class="mb-0">Gérez les dossiers médicaux de vos patients</p>
                </div>

                <!-- Search Section -->
                <div class="search-section">
                    <form class="row g-3" method="get">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text">
                                    <i class="fas fa-search"></i>
                                </span>
                                <input type="text" class="form-control" name="search" 
                                       value="${param.search}" placeholder="Rechercher un patient...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="filter">
                                <option value="">Tous les dossiers</option>
                                <option value="recent" ${param.filter eq 'recent' ? 'selected' : ''}>
                                    Consultations récentes
                                </option>
                                <option value="pending" ${param.filter eq 'pending' ? 'selected' : ''}>
                                    En attente de suivi
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn action-button w-100">
                                <i class="fas fa-filter me-2"></i>Filtrer
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Patients List -->
                <div class="patients-list">
                    <c:choose>
                        <c:when test="${empty patients}">
                            <div class="text-center py-5">
                                <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Aucun dossier médical trouvé</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${patients}" var="patient">
                                <div class="patient-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <div class="patient-info">
                                                <i class="fas fa-user"></i>
                                                <strong>${patient.utilisateur.nom} ${patient.utilisateur.prenom}</strong>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="patient-info">
                                                <i class="fas fa-calendar"></i>
                                                <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <span class="status-badge ${patient.actif ? 'status-active' : 'status-inactive'}">
                                                ${patient.actif ? 'Actif' : 'Inactif'}
                                            </span>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/medecin/dossiers/patient?id=${patient.id}" 
                                                   class="btn action-button">
                                                    <i class="fas fa-folder-open me-2"></i>Voir le dossier
                                                </a>
                                                <a href="${pageContext.request.contextPath}/medecin/rendez-vous/nouveau?patientId=${patient.id}" 
                                                   class="btn btn-light">
                                                    <i class="fas fa-calendar-plus me-2"></i>RDV
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${not empty patient.derniereConsultation}">
                                        <div class="last-visit mt-2">
                                            <i class="fas fa-clock me-2"></i>
                                            Dernière consultation: 
                                            <fmt:formatDate value="${patient.derniereConsultation}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 