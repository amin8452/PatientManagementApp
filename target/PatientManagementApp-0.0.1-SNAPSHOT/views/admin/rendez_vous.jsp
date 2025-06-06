<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Rendez-vous</title>
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
            color: rgb(255, 255, 255);
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

        .content-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .content-title {
            color: var(--primary-color);
            margin-bottom: 30px;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }

        .table tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.1);
        }

        .btn-primary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: 500;
        }

        .status-confirme {
            background-color: #28a745;
            color: white;
        }

        .status-annule {
            background-color: #dc3545;
            color: white;
        }

        .status-en-attente {
            background-color: #ffc107;
            color: #000;
        }

        .modal-header {
            background-color: var(--primary-color);
            color: white;
        }

        .modal-header .btn-close {
            color: white;
        }

        .form-label {
            color: var(--primary-color);
            font-weight: 500;
        }

        .form-control:focus {
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
                <h3 class="mb-4">Admin Panel</h3>
                <nav class="nav flex-column">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/statistiques">
                        <i class="fas fa-chart-bar me-2"></i>Statistiques
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/gestion-utilisateurs">
                        <i class="fas fa-users me-2"></i>Gestion utilisateurs
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <div class="content-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="content-title mb-0">Gestion des Rendez-vous</h2>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRendezVousModal">
                            <i class="fas fa-plus me-2"></i>Nouveau Rendez-vous
                        </button>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Heure</th>
                                    <th>Médecin</th>
                                    <th>Patient</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${rendezVous}" var="rdv">
                                    <tr>
                                        <td><fmt:formatDate value="${rdv.dateHeure}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${rdv.dateHeure}" pattern="HH:mm"/></td>
                                        <td>Dr. ${rdv.medecin.utilisateur.nom} ${rdv.medecin.utilisateur.prenom}</td>
                                        <td>${rdv.patient.utilisateur.nom} ${rdv.patient.utilisateur.prenom}</td>
                                        <td>
                                            <span class="status-badge status-${rdv.statut.toLowerCase()}">
                                                ${rdv.statut}
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-2" 
                                                    onclick="editRendezVous('${rdv.id}')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger" 
                                                    onclick="deleteRendezVous('${rdv.id}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Rendez-vous Modal -->
    <div class="modal fade" id="addRendezVousModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nouveau Rendez-vous</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/admin/rendez-vous" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="medecin" class="form-label">Médecin</label>
                            <select class="form-select" id="medecin" name="medecinId" required>
                                <option value="">Sélectionner un médecin</option>
                                <c:forEach items="${medecins}" var="medecin">
                                    <option value="${medecin.id}">
                                        Dr. ${medecin.utilisateur.nom} ${medecin.utilisateur.prenom} - ${medecin.specialite}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="patient" class="form-label">Patient</label>
                            <select class="form-select" id="patient" name="patientId" required>
                                <option value="">Sélectionner un patient</option>
                                <c:forEach items="${patients}" var="patient">
                                    <option value="${patient.id}">
                                        ${patient.utilisateur.nom} ${patient.utilisateur.prenom}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="date" class="form-label">Date</label>
                            <input type="date" class="form-control" id="date" name="date" required>
                        </div>

                        <div class="mb-3">
                            <label for="heure" class="form-label">Heure</label>
                            <input type="time" class="form-control" id="heure" name="heure" required>
                        </div>

                        <div class="mb-3">
                            <label for="statut" class="form-label">Statut</label>
                            <select class="form-select" id="statut" name="statut" required>
                                <option value="EN_ATTENTE">En attente</option>
                                <option value="CONFIRME">Confirmé</option>
                                <option value="ANNULE">Annulé</option>
                            </select>
                        </div>

                        <div class="d-flex justify-content-end">
                            <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>Annuler
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Enregistrer
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editRendezVous(id) {
            // Implémenter la logique d'édition
            window.location.href = '${pageContext.request.contextPath}/admin/rendez-vous?action=edit&id=' + id;
        }

        function deleteRendezVous(id) {
            if (confirm('Êtes-vous sûr de vouloir supprimer ce rendez-vous ?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/rendez-vous?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html> 