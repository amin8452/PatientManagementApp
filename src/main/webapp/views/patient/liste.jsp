<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Patients</title>
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

        .patients-table {
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
                    <a class="nav-link active" href="${pageContext.request.contextPath}/medecin/patients">
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
                        <h2 class="mb-0">Liste des Patients</h2>
                        <p class="mb-0">Gérez vos patients</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medecin/patients/nouveau" class="btn btn-light">
                        <i class="fas fa-user-plus me-2"></i>Nouveau Patient
                    </a>
                </div>

                <!-- Search Bar -->
                <div class="search-card">
                    <form action="${pageContext.request.contextPath}/medecin/patients" method="get" class="row g-3">
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control search-input" name="search" 
                                       placeholder="Rechercher un patient..." value="${param.search}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="filter">
                                <option value="">Tous les patients</option>
                                <option value="recent" ${param.filter eq 'recent' ? 'selected' : ''}>Consultations récentes</option>
                                <option value="upcoming" ${param.filter eq 'upcoming' ? 'selected' : ''}>Rendez-vous à venir</option>
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
                <div class="patients-table">
                    <c:choose>
                        <c:when test="${empty patients}">
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h4>Aucun patient trouvé</h4>
                                <p class="text-muted">Commencez par ajouter un nouveau patient</p>
                                <a href="${pageContext.request.contextPath}/medecin/patients/nouveau" class="btn action-button">
                                    <i class="fas fa-user-plus me-2"></i>Ajouter un patient
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Nom</th>
                                            <th>Date de naissance</th>
                                            <th>Email</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${patients}" var="patient">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="fas fa-user-circle fa-2x text-secondary me-3"></i>
                                                        <div>
                                                            <div class="fw-bold">${patient.utilisateur.nom} ${patient.utilisateur.prenom}</div>
                                                            <small class="text-muted">ID: ${patient.id}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>${patient.utilisateur.email}</td>
                                                <td>
                                                    <div class="btn-group">
                                                        <a href="${pageContext.request.contextPath}/medecin/patients/modifier?id=${patient.id}" 
                                                           class="btn btn-primary btn-sm">
                                                            <i class="fas fa-edit"></i> Modifier
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/medecin/dossiers/patient?id=${patient.id}" 
                                                           class="btn btn-info btn-sm">
                                                            <i class="fas fa-folder"></i> Dossier
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/medecin/patients/supprimer?id=${patient.id}" 
                                                           class="btn btn-danger btn-sm"
                                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce patient ?')">
                                                            <i class="fas fa-trash"></i> Supprimer
                                                        </a>
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