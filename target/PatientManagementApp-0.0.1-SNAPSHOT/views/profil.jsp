<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Mon profil" />
</jsp:include>

<div class="row">
    <div class="col-md-8 mx-auto">
        <div class="card">
            <div class="card-header">
                <h2>Mon profil</h2>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/profil" method="post">
                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom</label>
                        <input type="text" class="form-control" id="nom" name="nom" value="${sessionScope.utilisateur.nom}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="prenom" class="form-label">Prénom</label>
                        <input type="text" class="form-control" id="prenom" name="prenom" value="${sessionScope.utilisateur.prenom}" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" value="${sessionScope.utilisateur.email}" required>
                    </div>
                    
                    <hr>
                    <h5>Changer le mot de passe</h5>
                    <p class="text-muted small">Laissez vide si vous ne souhaitez pas changer votre mot de passe</p>
                    
                    <div class="mb-3">
                        <label for="ancienMotDePasse" class="form-label">Ancien mot de passe</label>
                        <input type="password" class="form-control" id="ancienMotDePasse" name="ancienMotDePasse">
                    </div>
                    
                    <div class="mb-3">
                        <label for="nouveauMotDePasse" class="form-label">Nouveau mot de passe</label>
                        <input type="password" class="form-control" id="nouveauMotDePasse" name="nouveauMotDePasse">
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmerMotDePasse" class="form-label">Confirmer le nouveau mot de passe</label>
                        <input type="password" class="form-control" id="confirmerMotDePasse" name="confirmerMotDePasse">
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Mettre à jour le profil</button>
                    </div>
                </form>
            </div>
        </div>
        
        <div class="mt-3">
            <c:choose>
                <c:when test="${sessionScope.utilisateur.role == 'admin'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary">Retour au tableau de bord</a>
                </c:when>
                <c:when test="${sessionScope.utilisateur.role == 'medecin'}">
                    <a href="${pageContext.request.contextPath}/medecin/dashboard" class="btn btn-outline-secondary">Retour au tableau de bord</a>
                </c:when>
                <c:when test="${sessionScope.utilisateur.role == 'patient'}">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-outline-secondary">Retour au tableau de bord</a>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // Validation du formulaire
    document.querySelector('form').addEventListener('submit', function(e) {
        var nouveauMotDePasse = document.getElementById('nouveauMotDePasse').value;
        var confirmerMotDePasse = document.getElementById('confirmerMotDePasse').value;
        var ancienMotDePasse = document.getElementById('ancienMotDePasse').value;
        
        // Si l'ancien mot de passe est renseigné, vérifier que les nouveaux mots de passe correspondent
        if (ancienMotDePasse && nouveauMotDePasse !== confirmerMotDePasse) {
            e.preventDefault();
            alert('Les nouveaux mots de passe ne correspondent pas.');
        }
    });
</script>

<jsp:include page="includes/footer.jsp" /> 