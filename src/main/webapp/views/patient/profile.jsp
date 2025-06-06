<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil</title>
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

        .profile-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: var(--light-bg);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 48px;
            color: var(--secondary-color);
        }

        .profile-name {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .profile-role {
            color: var(--secondary-color);
            font-size: 16px;
        }

        .info-section {
            margin-bottom: 30px;
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

        .form-control {
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
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
                <h3 class="mb-4">${sessionScope.utilisateur.nom}</h3>
                <nav class="nav flex-column">
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">
                        <i class="fas fa-tachometer-alt me-2"></i>Tableau de bord
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/rendez-vous">
                        <i class="fas fa-calendar-alt me-2"></i>Rendez-vous
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/patient/dossier">
                        <i class="fas fa-folder me-2"></i>Mon dossier
                    </a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/patient/profile">
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
                    <h2 class="mb-0">Mon Profil</h2>
                    <p class="mb-0">Gérez vos informations personnelles</p>
                </div>

                <!-- Profile Card -->
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <h2 class="profile-name">${patient.utilisateur.nom} ${patient.utilisateur.prenom}</h2>
                        <p class="profile-role">Patient</p>
                    </div>

                    <!-- Personal Information -->
                    <div class="info-section">
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

                    <!-- Update Profile Form -->
                    <div class="info-section">
                        <h5><i class="fas fa-edit me-2"></i>Modifier mes informations</h5>
                        <form action="${pageContext.request.contextPath}/patient/profile" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="numeroSecuriteSociale" class="form-label">Numéro de sécurité sociale</label>
                                    <input type="text" class="form-control" id="numeroSecuriteSociale" name="numeroSecuriteSociale" 
                                           value="${patient.numeroSecuriteSociale}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="dateNaissance" class="form-label">Date de naissance</label>
                                    <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" 
                                           value="<fmt:formatDate value='${patient.dateNaissance}' pattern='yyyy-MM-dd'/>" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="groupeSanguin" class="form-label">Groupe sanguin</label>
                                    <select class="form-control" id="groupeSanguin" name="groupeSanguin" required>
                                        <option value="">Sélectionnez un groupe</option>
                                        <option value="A+" ${patient.groupeSanguin == 'A+' ? 'selected' : ''}>A+</option>
                                        <option value="A-" ${patient.groupeSanguin == 'A-' ? 'selected' : ''}>A-</option>
                                        <option value="B+" ${patient.groupeSanguin == 'B+' ? 'selected' : ''}>B+</option>
                                        <option value="B-" ${patient.groupeSanguin == 'B-' ? 'selected' : ''}>B-</option>
                                        <option value="AB+" ${patient.groupeSanguin == 'AB+' ? 'selected' : ''}>AB+</option>
                                        <option value="AB-" ${patient.groupeSanguin == 'AB-' ? 'selected' : ''}>AB-</option>
                                        <option value="O+" ${patient.groupeSanguin == 'O+' ? 'selected' : ''}>O+</option>
                                        <option value="O-" ${patient.groupeSanguin == 'O-' ? 'selected' : ''}>O-</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="antecedentsMedicaux" class="form-label">Antécédents médicaux</label>
                                    <textarea class="form-control" id="antecedentsMedicaux" name="antecedentsMedicaux" 
                                              rows="3">${patient.antecedentsMedicaux}</textarea>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${patient.utilisateur.email}" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Nouveau mot de passe</label>
                                    <input type="password" class="form-control" id="password" name="password">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label">Confirmer le mot de passe</label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                                </div>
                            </div>
                            <div class="text-end">
                                <button type="submit" class="btn action-button">
                                    <i class="fas fa-save me-2"></i>Enregistrer les modifications
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password && password !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas.');
            }
        });
    </script>
</body>
</html>