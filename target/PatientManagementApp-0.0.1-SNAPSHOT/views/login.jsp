<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Connexion - Patient Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        /* style.css */
:root {
    --primary-color: #3498db;       /* Bleu principal */
    --secondary-color: #2980b9;     /* Bleu plus foncé */
    --accent-color: #e74c3c;        /* Rouge pour les accents */
    --light-color: #ecf0f1;         /* Fond clair */
    --dark-color: #2c3e50;          /* Texte foncé */
    --success-color: #2ecc71;        /* Vert pour succès */
    --danger-color: #e74c3c;        /* Rouge pour erreurs */
}

body {
    background-color: #f8f9fa;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: var(--dark-color);
    background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.container {
    animation: fadeIn 0.5s ease-in-out;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 0.3s ease;
}

.card:hover {
    transform: translateY(-5px);
}

.card-header {
    background-color: var(--primary-color);
    color: white;
    padding: 1.5rem;
    border-bottom: none;
}

.card-header h2 {
    font-weight: 700;
    font-size: 1.8rem;
}

.card-body {
    padding: 2rem;
}

.form-control {
    border: 2px solid #dfe6e9;
    border-radius: 8px;
    padding: 0.75rem 1rem;
    transition: all 0.3s;
}

.form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
}

.form-label {
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: var(--dark-color);
}

.btn-primary {
    background-color: var(--primary-color);
    border: none;
    border-radius: 8px;
    padding: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.5px;
    transition: all 0.3s;
}

.btn-primary:hover {
    background-color: var(--secondary-color);
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.alert {
    border-radius: 8px;
    padding: 1rem;
    border: none;
}

.alert-danger {
    background-color: #fdecea;
    color: var(--danger-color);
}

.alert-success {
    background-color: #e8f5e9;
    color: var(--success-color);
}

a {
    color: var(--primary-color);
    transition: color 0.3s;
}

a:hover {
    color: var(--secondary-color);
    text-decoration: underline;
}

/* Icônes */
.fas {
    margin-right: 8px;
}
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card">
                    <div class="card-header text-center">
                        <h2 class="mb-0"><i class="fas fa-user-circle me-2"></i>Connexion</h2>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-4">
                                <label class="form-label"><i class="fas fa-envelope me-2"></i>Email</label>
                                <input type="email" name="email" class="form-control" required 
                                       placeholder="Entrez votre email" />
                            </div>
                            <div class="mb-4">
                                <label class="form-label"><i class="fas fa-lock me-2"></i>Mot de passe</label>
                                <input type="password" name="motDePasse" class="form-control" required 
                                       placeholder="Entrez votre mot de passe" />
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg w-100">
                                <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                            </button>
                        </form>
                        
                        <div class="mt-4 text-center">
                            <a href="${pageContext.request.contextPath}/register" class="text-decoration-none">
                                <i class="fas fa-user-plus me-1"></i>Pas encore inscrit ? Créer un compte
                            </a>
                        </div>
                        
                        <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger mt-4">
                                <i class="fas fa-exclamation-circle me-2"></i>Identifiants invalides ou rôle non reconnu.
                            </div>
                        <% } %>
                        
                        <% if (request.getParameter("registered") != null) { %>
                            <div class="alert alert-success mt-4">
                                <i class="fas fa-check-circle me-2"></i>Inscription réussie ! Vous pouvez maintenant vous connecter.
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
