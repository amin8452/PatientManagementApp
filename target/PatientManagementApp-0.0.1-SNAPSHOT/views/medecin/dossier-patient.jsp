<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dossier Médical - ${patient.utilisateur.nom} ${patient.utilisateur.prenom}</title>
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

        .content-card {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .content-title {
            color: var(--primary-color);
            margin-bottom: 30px;
        }

        .patient-info {
            background-color: var(--light-bg);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .patient-info h3 {
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        .patient-info p {
            margin-bottom: 10px;
        }

        .patient-info strong {
            color: var(--primary-color);
        }

        .btn-primary {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .btn-primary:hover {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <h3 class="mb-4">Médecin Panel</h3>
                <nav class="nav flex-column">
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/patients">
                        <i class="fas fa-users me-2"></i>Mes patients
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/medecin/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/medecin/dossier-medical">
                        <i class="fas fa-file-medical me-2"></i>Dossiers médicaux
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
                        <h2 class="content-title mb-0">Dossier Médical</h2>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addConsultationModal">
                            <i class="fas fa-plus me-2"></i>Nouvelle Consultation
                        </button>
                    </div>

                    <!-- Patient Information -->
                    <div class="patient-info">
                        <h3>Informations du Patient</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Nom:</strong> ${patient.utilisateur.nom}</p>
                                <p><strong>Prénom:</strong> ${patient.utilisateur.prenom}</p>
                                <p><strong>Date de naissance:</strong> <fmt:formatDate value="${patient.dateNaissance}" pattern="dd/MM/yyyy"/></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Numéro de sécurité sociale:</strong> ${patient.numeroSecuriteSociale}</p>
                                <p><strong>Groupe sanguin:</strong> ${patient.groupeSanguin}</p>
                                <p><strong>Téléphone:</strong> ${patient.utilisateur.telephone}</p>
                                <p><strong>Email:</strong> ${patient.utilisateur.email}</p>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <p><strong>Antécédents médicaux:</strong></p>
                                <p>${patient.antecedentsMedicaux}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Consultations History -->
                    <div class="content-card">
                        <h3 class="content-title">Historique des Consultations</h3>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Diagnostic</th>
                                        <th>Traitement</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${consultations}" var="consultation">
                                        <tr>
                                            <td><fmt:formatDate value="${consultation.dateConsultation}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${consultation.diagnostic}</td>
                                            <td>${consultation.traitement}</td>
                                           <td>
    <button class="btn btn-sm btn-outline-primary me-2" 
            onclick="editConsultation('${consultation.id}')">
        <i class="fas fa-edit"></i>
    </button>
    <button class="btn btn-sm btn-outline-danger" 
            onclick="deleteConsultation('${consultation.id}')">
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
    </div>

    <!-- Add Consultation Modal -->
    <div class="modal fade" id="addConsultationModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nouvelle Consultation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/medecin/dossier-medical" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="patientId" value="${patient.id}">
                        
                        <div class="mb-3">
                            <label for="diagnostic" class="form-label">Diagnostic</label>
                            <textarea class="form-control" id="diagnostic" name="diagnostic" rows="3" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="traitement" class="form-label">Traitement</label>
                            <textarea class="form-control" id="traitement" name="traitement" rows="3" required></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="observations" class="form-label">Observations</label>
                            <textarea class="form-control" id="observations" name="observations" rows="3"></textarea>
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
        function editConsultation(id) {
            window.location.href = '${pageContext.request.contextPath}/medecin/dossier-medical?action=edit&id=' + id;
        }

        function deleteConsultation(id) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cette consultation ?')) {
                window.location.href = '${pageContext.request.contextPath}/medecin/dossier-medical?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html> 