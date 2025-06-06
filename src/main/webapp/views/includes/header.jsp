<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.title} - Centre Médical</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">Centre Médical</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <c:if test="${sessionScope.utilisateur != null}">
                        <c:choose>
                            <c:when test="${sessionScope.utilisateur.role == 'admin'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Tableau de bord</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/medecins">Médecins</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/patients">Patients</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/specialites">Spécialités</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/statistiques">Statistiques</a></li>
                            </c:when>
                            <c:when test="${sessionScope.utilisateur.role == 'medecin'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/medecin/dashboard">Tableau de bord</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/medecin/patients">Mes Patients</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/medecin/rendez-vous">Rendez-vous</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/medecin/dossiers">Dossiers médicaux</a></li>
                            </c:when>
                            <c:when test="${sessionScope.utilisateur.role == 'patient'}">
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/dashboard">Tableau de bord</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/rendez-vous">Mes Rendez-vous</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/dossier">Mon Dossier médical</a></li>
                                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/patient/medecins">Médecins</a></li>
                            </c:when>
                        </c:choose>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${sessionScope.utilisateur != null}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    ${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profil">Mon profil</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Déconnexion</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/views/login.jsp">Connexion</a></li>
                            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Inscription</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType} alert-dismissible fade show">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>
</body>
</html> 