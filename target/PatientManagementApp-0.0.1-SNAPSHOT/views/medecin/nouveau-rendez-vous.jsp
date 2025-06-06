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

        .patient-search {
            position: relative;
        }

        .search-results {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            max-height: 200px;
            overflow-y: auto;
        }

        .search-result-item {
            padding: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-result-item:hover {
            background-color: var(--light-bg);
        }

        .selected-patient {
            background-color: var(--light-bg);
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }

        .selected-patient i {
            color: var(--secondary-color);
            margin-right: 10px;
        }

        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 10px;
            margin-top: 10px;
        }

        .time-slot {
            padding: 8px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .time-slot:hover {
            background-color: var(--light-bg);
        }

        .time-slot.selected {
            background-color: var(--secondary-color);
            color: white;
            border-color: var(--secondary-color);
        }

        .time-slot.unavailable {
            background-color: #f8d7da;
            color: #721c24;
            cursor: not-allowed;
            opacity: 0.7;
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
                        <h2 class="mb-0">Nouveau Rendez-vous</h2>
                        <p class="mb-0">Planifier un nouveau rendez-vous</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/medecin/rendez-vous" class="btn btn-light">
                        <i class="fas fa-arrow-left me-2"></i>Retour
                    </a>
                </div>

                <!-- Appointment Form -->
                <div class="form-card">
                    <form action="${pageContext.request.contextPath}/medecin/rendez-vous/nouveau" method="post">
                        <!-- Patient Selection -->
                        <div class="form-section">
                            <h5><i class="fas fa-user me-2"></i>Sélection du patient</h5>
                            <div class="patient-search">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" id="patientSearch" 
                                           placeholder="Rechercher un patient par nom ou prénom...">
                                </div>
                                <div class="search-results" style="display: none;">
                                    <!-- Search results will be populated dynamically -->
                                </div>
                            </div>
                            <div class="selected-patient" style="display: none;">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-user-circle fa-2x"></i>
                                    <div>
                                        <h6 class="mb-1 patient-name"></h6>
                                        <small class="text-muted patient-info"></small>
                                    </div>
                                </div>
                                <input type="hidden" name="patientId" id="patientId">
                            </div>
                        </div>

                        <!-- Date and Time Selection -->
                        <div class="form-section">
                            <h5><i class="fas fa-calendar-alt me-2"></i>Date et heure</h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="date" class="form-label">Date</label>
                                    <input type="date" class="form-control" id="date" name="date" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Heure</label>
                                    <div class="time-slots">
                                        <!-- Time slots will be populated dynamically -->
                                    </div>
                                    <input type="hidden" name="heure" id="heure">
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
                                <label for="notes" class="form-label">Notes additionnelles</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" 
                                          placeholder="Ajoutez des notes ou commentaires..."></textarea>
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
        // Patient search functionality
        const patientSearch = document.getElementById('patientSearch');
        const searchResults = document.querySelector('.search-results');
        const selectedPatient = document.querySelector('.selected-patient');
        const patientId = document.getElementById('patientId');

        patientSearch.addEventListener('input', async (e) => {
            const query = e.target.value;
            if (query.length < 2) {
                searchResults.style.display = 'none';
                return;
            }

            try {
                const response = await fetch(`${pageContext.request.contextPath}/api/patients/search?q=${query}`);
                const patients = await response.json();
                
                searchResults.innerHTML = patients.map(patient => `
                    <div class="search-result-item" data-id="${patient.id}">
                        <div class="fw-bold">${patient.nom} ${patient.prenom}</div>
                        <small class="text-muted">${patient.telephone}</small>
                    </div>
                `).join('');
                
                searchResults.style.display = 'block';
            } catch (error) {
                console.error('Error searching patients:', error);
            }
        });

        searchResults.addEventListener('click', (e) => {
            const item = e.target.closest('.search-result-item');
            if (item) {
                const id = item.dataset.id;
                const name = item.querySelector('.fw-bold').textContent;
                const info = item.querySelector('small').textContent;

                patientId.value = id;
                selectedPatient.querySelector('.patient-name').textContent = name;
                selectedPatient.querySelector('.patient-info').textContent = info;
                selectedPatient.style.display = 'block';
                searchResults.style.display = 'none';
                patientSearch.value = '';
            }
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