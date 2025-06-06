package dao;

import model.Patient;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import java.util.Date;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class PatientDAO {
    public void save(Patient patient) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(patient);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void update(Patient patient) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(patient);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void delete(Patient patient) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(patient);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public Patient findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(Patient.class, id);
        } finally {
            session.close();
        }
    }

    public List<Patient> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery("FROM Patient", Patient.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public Patient findByUtilisateur(int utilisateurId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery("FROM Patient WHERE utilisateur.id = :utilisateurId", Patient.class);
            query.setParameter("utilisateurId", utilisateurId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public long countByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(p) FROM Patient p " +
                "WHERE EXISTS (SELECT d FROM DossierMedical d " +
                "WHERE d.patient = p AND d.medecin.id = :medecinId)", 
                Long.class
            );
            query.setParameter("medecinId", medecinId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public List<Patient> findByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery(
                "SELECT p FROM Patient p " +
                "JOIN p.dossierMedical d " +
                "WHERE d.medecin.id = :medecinId " +
                "ORDER BY p.utilisateur.nom, p.utilisateur.prenom", 
                Patient.class
            );
            query.setParameter("medecinId", medecinId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Patient> findByMedecinAndDateInscription(int medecinId, Date startDate, Date endDate) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery(
                "SELECT p FROM Patient p " +
                "JOIN p.dossierMedical d " +
                "WHERE d.medecin.id = :medecinId " +
                "AND p.utilisateur.dateInscription BETWEEN :startDate AND :endDate " +
                "ORDER BY p.utilisateur.dateInscription DESC", 
                Patient.class
            );
            query.setParameter("medecinId", medecinId);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Patient> searchPatients(String searchTerm) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery(
                "FROM Patient p " +
                "WHERE LOWER(p.utilisateur.nom) LIKE LOWER(:searchTerm) " +
                "OR LOWER(p.utilisateur.prenom) LIKE LOWER(:searchTerm) " +
                "OR LOWER(p.utilisateur.email) LIKE LOWER(:searchTerm) " +
                "ORDER BY p.utilisateur.nom, p.utilisateur.prenom", 
                Patient.class
            );
            query.setParameter("searchTerm", "%" + searchTerm + "%");
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Patient> findPatientsWithoutDossier() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Patient> query = session.createQuery(
                "FROM Patient p " +
                "WHERE NOT EXISTS (SELECT d FROM DossierMedical d WHERE d.patient = p) " +
                "ORDER BY p.utilisateur.nom, p.utilisateur.prenom", 
                Patient.class
            );
            return query.list();
        } finally {
            session.close();
        }
    }

    public long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
