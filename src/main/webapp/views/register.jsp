<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Patient Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card">
                <div class="card-header text-center">
                    <h2 class="mb-0"><i class="fas fa-user-plus me-2"></i>Inscription</h2>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label"><i class="fas fa-user me-2"></i>Nom</label>
                                <input type="text" class="form-control" id="nom" name="nom" required
                                       placeholder="Entrez votre nom">
                            </div>

                            <div class="col-md-6 mb-4">
                                <label class="form-label"><i class="fas fa-user me-2"></i>Prénom</label>
                                <input type="text" class="form-control" id="prenom" name="prenom" required
                                       placeholder="Entrez votre prénom">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
                            <input type="email" class="form-control" id="email" name="email" required
                                   placeholder="Entrez votre email">
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <label class="form-label"><i class="fas fa-lock me-2"></i>Mot de passe</label>
                                <input type="password" class="form-control" id="motDePasse" name="motDePasse" required
                                       placeholder="Créez un mot de passe">
                            </div>

                            <div class="col-md-6 mb-4">
                                <label class="form-label"><i class="fas fa-lock me-2"></i>Confirmer le mot de passe</label>
                                <input type="password" class="form-control" id="confirmerMotDePasse" name="confirmerMotDePasse" required
                                       placeholder="Confirmez le mot de passe">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label"><i class="fas fa-user-tag me-2"></i>Type de compte</label>
                            <select class="form-select" id="role" name="role" required onchange="toggleMedecinFields()">
                                <option value="patient">Patient</option>
                                <option value="medecin">Médecin</option>
                            </select>
                        </div>

                        <!-- Doctor-specific fields -->
                        <div id="medecinFields" class="border rounded p-3 mb-4" style="display: none;">
                            <h5 class="mb-3"><i class="fas fa-stethoscope me-2"></i>Informations du médecin</h5>
                            
                            <div class="mb-4">
                                <label class="form-label"><i class="fas fa-user-md me-2"></i>Spécialité</label>
                                <select class="form-select" id="specialite" name="specialite">
                                    <c:forEach items="${specialites}" var="specialite">
                                        <option value="${specialite.id}">${specialite.nom}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-4">
                                <label class="form-label"><i class="fas fa-id-card me-2"></i>Numéro d'ordre des médecins</label>
                                <input type="text" class="form-control" id="numeroOrdre" name="numeroOrdre"
                                       placeholder="Entrez votre numéro d'ordre">
                            </div>

                            <div class="mb-4">
                                <label class="form-label"><i class="fas fa-clock me-2"></i>Années d'expérience</label>
                                <input type="number" class="form-control" id="anneesExperience" name="anneesExperience" min="0"
                                       placeholder="Nombre d'années d'expérience">
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-plus me-2"></i>S'inscrire
                            </button>
                        </div>

                        <div class="text-center mt-4">
                            <p class="mb-0">Déjà inscrit? 
                                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                                    <i class="fas fa-sign-in-alt me-1"></i>Se connecter
                                </a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<script>
function toggleMedecinFields() {
    var role = document.getElementById('role').value;
    var medecinFields = document.getElementById('medecinFields');
    var specialite = document.getElementById('specialite');
    var numeroOrdre = document.getElementById('numeroOrdre');
    var anneesExperience = document.getElementById('anneesExperience');
    
    if (role === 'medecin') {
        medecinFields.style.display = 'block';
        specialite.required = true;
        numeroOrdre.required = true;
        anneesExperience.required = true;
    } else {
        medecinFields.style.display = 'none';
        specialite.required = false;
        numeroOrdre.required = false;
        anneesExperience.required = false;
    }
}

// Form validation
document.querySelector('form').addEventListener('submit', function(e) {
    var motDePasse = document.getElementById('motDePasse').value;
    var confirmerMotDePasse = document.getElementById('confirmerMotDePasse').value;

    if (motDePasse !== confirmerMotDePasse) {
        e.preventDefault();
        alert('Les mots de passe ne correspondent pas!');
    }
});

// Initialize fields visibility on page load
document.addEventListener('DOMContentLoaded', toggleMedecinFields);
</script>
</body>
</html>