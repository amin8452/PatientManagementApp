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

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .info-card h5 {
            color: var(--primary-color);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-bg);
        }

        .info-section {
            background-color: var(--light-bg);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .info-section i {
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

        .patient-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .patient-info i {
            font-size: 2rem;
            color: var(--secondary-color);
            margin-right: 15px;
        }

        .patient-details {
            flex-grow: 1;
        }

        .patient-name {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .patient-contact {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 10px;
            top: 0;
            bottom: 0;
            width: 2px;
            background-color: var(--light-bg);
        }

        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -30px;
            top: 0;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: var(--secondary-color);
            border: 3px solid white;
        }

        .timeline-date {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 5px;
        }

        .timeline-content {
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
                        <h2 class="mb-0">Détails du Rendez-vous</h2>
                        <p class="mb-0">Informations et historique</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medecin/rendez-vous" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>

                <!-- Appointment Information -->
                <div class="info-card">
                    <div class="row">
                        <div class="col-md-8">
                            <!-- Patient Information -->
                            <div class="patient-info">
                                <i class="fas fa-user-circle"></i>
                                <div class="patient-details">
                                    <div class="patient-name">
                                        ${rendezVous.patient.utilisateur.nom} ${rendezVous.patient.utilisateur.prenom}
                                    </div>
                                    <div class="patient-contact">
                                        <i class="fas fa-phone me-2"></i>${rendezVous.patient.utilisateur.telephone}
                                        <i class="fas fa-envelope ms-3 me-2"></i>${rendezVous.patient.utilisateur.email}
                                    </div>
                                </div>
                            </div>

                            <!-- Appointment Details -->
                            <div class="info-section">
                                <h5><i class="fas fa-calendar-check me-2"></i>Détails du rendez-vous</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><i class="fas fa-clock me-2"></i>Date et heure</p>
                                        <p class="ms-4">
                                            <fmt:formatDate value="${rendezVous.dateHeure}" pattern="dd/MM/yyyy"/>
                                            à <fmt:formatDate value="${rendezVous.dateHeure}" pattern="HH:mm"/>
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><i class="fas fa-stethoscope me-2"></i>Type de consultation</p>
                                        <p class="ms-4">${rendezVous.typeConsultation}</p>
                                    </div>
                                </div>
                                <div class="mt-3">
                                    <p><i class="fas fa-clipboard me-2"></i>Notes</p>
                                    <p class="ms-4">${rendezVous.notes}</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <!-- Status and Actions -->
                            <div class="info-section">
                                <h5><i class="fas fa-info-circle me-2"></i>Statut</h5>
                                <div class="text-center mb-3">
                                    <span class="status-badge ${rendezVous.statut eq 'en attente' ? 'status-pending' : 
                                                              rendezVous.statut eq 'accepté' ? 'status-confirmed' : 
                                                              'status-cancelled'}">
                                        ${rendezVous.statut}
                                    </span>
                                </div>
                                <c:if test="${rendezVous.statut eq 'en attente'}">
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/medecin/rendez-vous/${rendezVous.id}/accepter" 
                                           class="btn btn-success">
                                            <i class="fas fa-check me-2"></i>Accepter
                                        </a>
                                        <a href="${pageContext.request.contextPath}/medecin/rendez-vous/${rendezVous.id}/annuler" 
                                           class="btn btn-danger">
                                            <i class="fas fa-times me-2"></i>Annuler
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Appointment History -->
                <div class="info-card">
                    <h5><i class="fas fa-history me-2"></i>Historique</h5>
                    <div class="timeline">
                        <c:forEach items="${historique}" var="event">
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <fmt:formatDate value="${event.date}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                                <div class="timeline-content">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${event.action}</strong>
                                            <c:if test="${not empty event.commentaire}">
                                                <p class="mb-0 mt-1">${event.commentaire}</p>
                                            </c:if>
                                        </div>
                                        <small class="text-muted">Par ${event.utilisateur.nom}</small>
                                    </div>
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