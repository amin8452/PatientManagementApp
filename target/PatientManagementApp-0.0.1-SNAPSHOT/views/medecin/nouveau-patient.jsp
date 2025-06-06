<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Patient</title>
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

        .form-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-card h5 {
            color: var(--primary-color);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-bg);
        }

        .form-label {
            color: var(--primary-color);
            font-weight: 500;
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

        .form-section {
            background-color: var(--light-bg);
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .form-section i {
            color: var(--secondary-color);
            margin-right: 10px;
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
                        <h2 class="mb-0">Nouveau Patient</h2>
                        <p class="mb-0">Ajouter un nouveau patient à votre liste</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medecin/patients" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>

                <!-- Patient Form -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/medecin/patients/nouveau" method="post">
                        <!-- Personal Information -->
                        <div class="form-section">
                            <h5><i class="fas fa-user me-2"></i>Informations personnelles</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nom" class="form-label">Nom</label>
                                    <input type="text" class="form-control" id="nom" name="nom" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="prenom" class="form-label">Prénom</label>
                                    <input type="text" class="form-control" id="prenom" name="prenom" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="dateNaissance" class="form-label">Date de naissance</label>
                                    <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="sexe" class="form-label">Sexe</label>
                                    <select class="form-select" id="sexe" name="sexe" required>
                                        <option value="">Sélectionnez</option>
                                        <option value="M">Masculin</option>
                                        <option value="F">Féminin</option>
                                        <option value="A">Autre</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Information -->
                        <div class="form-section">
                            <h5><i class="fas fa-address-book me-2"></i>Informations de contact</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="telephone" class="form-label">Téléphone</label>
                                    <input type="tel" class="form-control" id="telephone" name="telephone" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="adresse" class="form-label">Adresse</label>
                                <textarea class="form-control" id="adresse" name="adresse" rows="2" required></textarea>
                            </div>
                        </div>

                        <!-- Medical Information -->
                        <div class="form-section">
                            <h5><i class="fas fa-notes-medical me-2"></i>Informations médicales</h5>
                            <div class="mb-3">
                                <label for="groupeSanguin" class="form-label">Groupe sanguin</label>
                                <select class="form-select" id="groupeSanguin" name="groupeSanguin">
                                    <option value="">Sélectionnez</option>
                                    <option value="A+">A+</option>
                                    <option value="A-">A-</option>
                                    <option value="B+">B+</option>
                                    <option value="B-">B-</option>
                                    <option value="AB+">AB+</option>
                                    <option value="AB-">AB-</option>
                                    <option value="O+">O+</option>
                                    <option value="O-">O-</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="allergies" class="form-label">Allergies</label>
                                <textarea class="form-control" id="allergies" name="allergies" rows="2" 
                                          placeholder="Listez les allergies connues..."></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="antecedents" class="form-label">Antécédents médicaux</label>
                                <textarea class="form-control" id="antecedents" name="antecedents" rows="3" 
                                          placeholder="Décrivez les antécédents médicaux importants..."></textarea>
                            </div>
                        </div>

                        <!-- Emergency Contact -->
                        <div class="form-section">
                            <h5><i class="fas fa-phone-alt me-2"></i>Contact d'urgence</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="urgenceNom" class="form-label">Nom du contact</label>
                                    <input type="text" class="form-control" id="urgenceNom" name="urgenceNom" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="urgenceTelephone" class="form-label">Téléphone</label>
                                    <input type="tel" class="form-control" id="urgenceTelephone" name="urgenceTelephone" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="urgenceRelation" class="form-label">Relation</label>
                                <input type="text" class="form-control" id="urgenceRelation" name="urgenceRelation" 
                                       placeholder="Ex: Conjoint, Parent, Enfant..." required>
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn action-button">
                                <i class="fas fa-user-plus me-2"></i>Ajouter le patient
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 