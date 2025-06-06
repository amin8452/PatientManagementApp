<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Rendez-vous</title>
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
            color: rgb(81, 81, 81);
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
            color: rgb(119, 119, 119);
        }

        .sidebar .nav-link.active {
            background-color: var(--secondary-color);
            color: rgb(107, 105, 105);
        }

        .main-content {
            padding: 20px;
        }

        .page-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: rgb(137, 136, 136);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .appointment-card {
            background: rgb(140, 140, 140);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .appointment-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--light-bg);
        }

        .appointment-icon {
            font-size: 2rem;
            color: var(--secondary-color);
            margin-right: 15px;
        }

        .appointment-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 0;
        }

        .info-section {
            margin-bottom: 20px;
        }

        .info-section h5 {
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

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .status-pending {
            background-color: #ffffff;
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

        .action-button {
            background-color: var(--secondary-color);
            color: rgb(189, 189, 189);
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .action-button:hover {
            background-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .action-button.danger {
            background-color: var(--accent-color);
        }

        .action-button.danger:hover {
            background-color: #c0392b;
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
                        <h2 class="mb-0">Détails du Rendez-vous</h2>
                        <p class="mb-0">Informations sur votre rendez-vous médical</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/rendez-vous" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>

                <!-- Appointment Details -->
                <div class="appointment-card">
                    <div class="appointment-header">
                        <i class="fas fa-calendar-check appointment-icon"></i>
                        <h3 class="appointment-title">Rendez-vous #${rendezVous.id}</h3>
                    </div>

                    <!-- Appointment Information -->
                    <div class="info-section">
                        <h5><i class="fas fa-info-circle me-2"></i>Informations du rendez-vous</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <i class="fas fa-calendar"></i>
                                    <span class="info-label">Date:</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${rendezVous.dateHeure}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span class="info-label">Heure:</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${rendezVous.dateHeure}" pattern="HH:mm"/>
                                    </span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <i class="fas fa-stethoscope"></i>
                                    <span class="info-label">Type:</span>
                                    <span class="info-value">${rendezVous.typeConsultation}</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-info-circle"></i>
                                    <span class="info-label">Statut:</span>
                                    <span class="status-badge ${rendezVous.statut eq 'en attente' ? 'status-pending' : 
                                                              rendezVous.statut eq 'accepté' ? 'status-confirmed' : 
                                                              'status-cancelled'}">
                                        ${rendezVous.statut}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Doctor Information -->
                    <div class="info-section">
                        <h5><i class="fas fa-user-md me-2"></i>Informations du médecin</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-item">
                                    <i class="fas fa-user"></i>
                                    <span class="info-label">Nom:</span>
                                    <span class="info-value">Dr. ${rendezVous.medecin.utilisateur.nom}</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-item">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span class="info-label">Spécialité:</span>
                                    <span class="info-value">${rendezVous.medecin.specialite.nom}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Consultation Details -->
                    <div class="info-section">
                        <h5><i class="fas fa-clipboard-list me-2"></i>Détails de la consultation</h5>
                        <div class="info-item">
                            <i class="fas fa-comment"></i>
                            <span class="info-label">Motif:</span>
                            <span class="info-value">${rendezVous.motif}</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="text-end">
                        <c:if test="${rendezVous.statut eq 'en attente'}">
                            <a href="${pageContext.request.contextPath}/patient/rendez-vous/${rendezVous.id}/annuler" 
                               class="btn action-button danger me-2">
                                <i class="fas fa-times me-2"></i>Annuler le rendez-vous
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/patient/rendez-vous" class="btn action-button">
                            <i class="fas fa-arrow-left me-2"></i>Retour à la liste
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>