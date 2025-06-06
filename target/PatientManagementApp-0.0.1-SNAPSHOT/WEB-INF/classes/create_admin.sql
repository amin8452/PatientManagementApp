-- Create database if not exists
CREATE DATABASE IF NOT EXISTS gestion_medicale;
USE gestion_medicale;

-- Create admin user
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role, date_inscription)
VALUES (
    'Admin',
    'System',
    'admin@admin.com',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- This is the SHA-256 hash of 'admin123'
    'admin',
    NOW()
); 