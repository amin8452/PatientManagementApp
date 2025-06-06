<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Dossier Médical</title>
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

        .medical-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .medical-card h5 {
            color: var(--primary-color);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-bg);
        }

        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            background-color: var(--light-bg);
            border-radius: 5px;
        }

        .info-item i {
            color: var(--secondary-color);
            font-size: 1.2rem;
            margin-right: 15px;
            width: 24px;
            text-align: center;
        }

        .info-label {
            font-weight: 500;
            color: var(--primary-color);
            margin-right: 10px;
        }

        .info-value {
            color: var(--dark-bg);
        }

        .history-item {
            padding: 15px;
            border-left: 3px solid var(--secondary-color);
            margin-bottom: 15px;
            background-color: white;
            border-radius: 0 5px 5px 0;
        }

        .history-date {
            color: var(--secondary-color);
            font-weight: 500;
            margin-bottom: 5px;
        }

        .history-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 5px;
        }

        .history-description {
            color: var(--dark-bg);
            font-size: 0.9rem;
        }

        .document-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .document-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .document-icon {
            font-size: 2rem;
            color: var(--secondary-color);
            margin-right: 15px;
        }

        .document-info {
            flex-grow: 1;
        }

        .document-title {
            font-weight: 500;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .document-meta {
            font-size: 0.9rem;
            color: var(--dark-bg);
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/dossier">
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
                <div class="page-header">
                    <h2 class="mb-0">Mon Dossier Médical</h2>
                    <p class="mb-0">Consultez votre historique médical et vos documents</p>
                </div>

                <!-- Personal Information -->
                <div class="medical-card">
                    <h5><i class="fas fa-user me-2"></i>Informations Personnelles</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <i class="fas fa-id-card"></i>
                                <span class="info-label">Nom:</span>
                                <span class="info-value">${patient.utilisateur.nom}</span>
                            </div>
                            <div class="info-item">
                                <i class="fas fa-birthday-cake"></i>
                                <span class="info-label">Date de naissance:</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item">
                                <i class="fas fa-envelope"></i>
                                <span class="info-label">Email:</span>
                                <span class="info-value">${patient.utilisateur.email}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Medical History -->
                <div class="medical-card">
                    <h5><i class="fas fa-history me-2"></i>Historique Médical</h5>
                    <c:forEach items="${historiqueMedical}" var="historique">
                        <div class="history-item">
                            <div class="history-date">
                                <fmt:formatDate value="${historique.date}" pattern="dd/MM/yyyy"/>
                            </div>
                            <div class="history-title">${historique.type}</div>
                            <div class="history-description">${historique.description}</div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Medical Documents -->
                <div class="medical-card">
                    <h5><i class="fas fa-file-medical me-2"></i>Documents Médicaux</h5>
                    <div class="row">
                        <c:forEach items="${documents}" var="document">
                            <div class="col-md-6">
                                <div class="document-card">
                                    <i class="fas fa-file-pdf document-icon"></i>
                                    <div class="document-info">
                                        <div class="document-title">${document.nom}</div>
                                        <div class="document-meta">
                                            Ajouté le <fmt:formatDate value="${document.dateAjout}" pattern="dd/MM/yyyy"/>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/patient/dossier/document/${document.id}/telecharger" 
                                       class="btn action-button">
                                        <i class="fas fa-download me-2"></i>Télécharger
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 