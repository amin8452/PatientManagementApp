<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouveau Rendez-vous</title>
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

        .doctor-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .doctor-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .doctor-card.selected {
            border: 2px solid var(--secondary-color);
        }

        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 12px;
            margin-top: 15px;
        }

        .time-slot {
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background-color: white;
            font-weight: 500;
            color: var(--primary-color);
            position: relative;
            overflow: hidden;
        }

        .time-slot:hover:not(.unavailable) {
            border-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.1);
        }

        .time-slot.selected {
            background-color: var(--secondary-color);
            color: white;
            border-color: var(--secondary-color);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.2);
        }

        .time-slot.unavailable {
            background-color: #f8f9fa;
            color: #adb5bd;
            border-color: #e9ecef;
            cursor: not-allowed;
            position: relative;
        }

        .time-slot.unavailable::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #dc3545;
            transform: rotate(-45deg);
        }

        .time-slot.unavailable::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background-color: #dc3545;
            transform: rotate(45deg);
        }

        .time-slot-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 4px;
        }

        .time-slot.selected .time-slot-label {
            color: rgba(255, 255, 255, 0.9);
        }

        .time-slots-container {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .time-slots-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .time-slots-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin: 0;
        }

        .time-slots-subtitle {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
        }
        .form-select{
            width: 100%;
        }   
        .time-slot-select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background-color: white;
            color: var(--primary-color);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%232c3e50' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
        }

        .time-slot-select:hover {
            border-color: var(--secondary-color);
        }

        .time-slot-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
            outline: none;
        }

        .time-slot-select option {
            padding: 12px;
            font-weight: 500;
        }

        .time-slot-select option:disabled {
            color: #adb5bd;
            background-color: #f8f9fa;
        }

        .time-slot-group {
            font-weight: 600;
            color: var(--primary-color);
            background-color: #f8f9fa;
            padding: 8px 12px;
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
                        <h2 class="mb-0">Nouveau Rendez-vous</h2>
                        <p class="mb-0">Planifiez votre rendez-vous médical</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/rendez-vous" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>

                <!-- Appointment Form -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/patient/rendez-vous/nouveau" method="post">
                        <!-- Doctor Selection -->
                        <div class="form-section">
                            <h5><i class="fas fa-user-md me-2"></i>Sélection du médecin</h5>
                            <div class="row">
                                <c:forEach items="${medecins}" var="medecin">
                                    <div class="col-md-4">
                                        <div class="doctor-card" data-id="${medecin.id}">
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-user-md fa-2x text-secondary me-3"></i>
                                                <div>
                                                    <h6 class="mb-1">Dr. ${medecin.utilisateur.nom}</h6>
                                                    <small class="text-muted">${medecin.specialite.nom}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <input type="hidden" name="medecinId" id="medecinId" required>
                        </div>

                        <!-- Date and Time Selection -->
                        <div class="form-section">
                            <h5><i class="fas fa-calendar-alt me-2"></i>Date et heure</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="date" class="form-label">Date</label>
                                    <input type="date" class="form-control" id="date" name="date" required min="${java.time.LocalDate.now()}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="heure" class="form-label">Heure</label>
                                    <select class="time-slot-select" id="heure" name="heure" required>
                                        <option value="">Sélectionnez l'heure</option>
                                        <optgroup label="Matin" class="time-slot-group">
                                            <option value="08:00">08:00</option>
                                            <option value="09:00">09:00</option>
                                            <option value="10:00">10:00</option>
                                            <option value="11:00">11:00</option>
                                        </optgroup>
                                        <optgroup label="Midi" class="time-slot-group">
                                            <option value="12:00">12:00</option>
                                        </optgroup>
                                        <optgroup label="Après-midi" class="time-slot-group">
                                            <option value="13:00">13:00</option>
                                            <option value="14:00">14:00</option>
                                            <option value="15:00">15:00</option>
                                            <option value="16:00">16:00</option>
                                        </optgroup>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Consultation Type -->
                        <div class="form-section">
                            <h5><i class="fas fa-stethoscope me-2"></i>Type de consultation</h5>
                            <div class="mb-3">
                                <select class="form-select" name="typeConsultation" required>
                                    <option value="">Sélectionnez le type de consultation</option>
                                    <option value="Consultation générale">Consultation générale</option>
                                    <option value="Suivi">Suivi</option>
                                    <option value="Urgence">Urgence</option>
                                    <option value="Vaccination">Vaccination</option>
                                    <option value="Autre">Autre</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="motif" class="form-label">Motif de la consultation</label>
                                <textarea class="form-control" id="motif" name="motif" rows="3" 
                                          placeholder="Décrivez brièvement le motif de votre consultation..." required></textarea>
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="submit" class="btn action-button">
                                <i class="fas fa-calendar-plus me-2"></i>Planifier le rendez-vous
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Doctor selection
        const doctorCards = document.querySelectorAll('.doctor-card');
        const medecinIdInput = document.getElementById('medecinId');

        doctorCards.forEach(card => {
            card.addEventListener('click', () => {
                doctorCards.forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
                medecinIdInput.value = card.dataset.id;
            });
        });

        // Time slots generation
        const dateInput = document.getElementById('date');
        const timeSlots = document.querySelector('.time-slots');
        const heureInput = document.getElementById('heure');

        dateInput.addEventListener('change', async (e) => {
            const date = e.target.value;
            if (!date) return;

            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/rendez-vous/disponibilites?date=${date}`);
                const disponibilites = await response.json();
                
                timeSlots.innerHTML = disponibilites.map(slot => `
                    <div class="time-slot ${slot.disponible ? '' : 'unavailable'}" 
                         data-heure="${slot.heure}"
                         ${slot.disponible ? '' : 'disabled'}>
                        ${slot.heure}
                    </div>
                `).join('');
            } catch (error) {
                console.error('Error fetching time slots:', error);
            }
        });

        timeSlots.addEventListener('click', (e) => {
            const slot = e.target.closest('.time-slot');
            if (slot && !slot.classList.contains('unavailable')) {
                document.querySelectorAll('.time-slot').forEach(s => s.classList.remove('selected'));
                slot.classList.add('selected');
                heureInput.value = slot.dataset.heure;
            }
        });
    </script>
</body>
</html> 