package dao;

import model.MedicalRecord;
import model.MedicalDocument;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import java.util.Date;

public class MedicalRecordDAO {
    public void save(MedicalRecord dossier) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(dossier);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void update(MedicalRecord dossier) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(dossier);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void delete(MedicalRecord dossier) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(dossier);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public MedicalRecord findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(MedicalRecord.class, id);
        } finally {
            session.close();
        }
    }

    public List<MedicalRecord> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalRecord> query = session.createQuery("FROM MedicalRecord", MedicalRecord.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public MedicalDocument findDocumentById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(MedicalDocument.class, id);
        } finally {
            session.close();
        }
    }

    public void addDocument(MedicalDocument document) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(document);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public List<MedicalRecord> findByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalRecord> query = session.createQuery("FROM MedicalRecord WHERE medecin.id = :medecinId", MedicalRecord.class);
            query.setParameter("medecinId", medecinId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public MedicalRecord findByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalRecord> query = session.createQuery("FROM MedicalRecord WHERE patient.id = :patientId", MedicalRecord.class);
            query.setParameter("patientId", patientId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public long countByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(d) FROM MedicalRecord d " +
                "WHERE d.medecin.id = :medecinId", 
                Long.class
            );
            query.setParameter("medecinId", medecinId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public List<MedicalRecord> findByMedecinAndDateRange(int medecinId, Date startDate, Date endDate) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalRecord> query = session.createQuery(
                "FROM MedicalRecord d " +
                "WHERE d.medecin.id = :medecinId " +
                "AND d.lastUpdate BETWEEN :startDate AND :endDate " +
                "ORDER BY d.lastUpdate DESC", 
                MedicalRecord.class
            );
            query.setParameter("medecinId", medecinId);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<MedicalDocument> findDocumentsByDossier(int dossierId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalDocument> query = session.createQuery(
                "FROM MedicalDocument d " +
                "WHERE d.dossierMedical.id = :dossierId", 
                MedicalDocument.class
            );
            query.setParameter("dossierId", dossierId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public void deleteDocument(int documentId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            MedicalDocument document = session.get(MedicalDocument.class, documentId);
            if (document != null) {
                session.delete(document);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public List<MedicalRecord> findRecentlyUpdated(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<MedicalRecord> query = session.createQuery(
                "FROM MedicalRecord d " +
                "ORDER BY d.lastUpdate DESC", 
                MedicalRecord.class
            );
            query.setMaxResults(limit);
            return query.list();
        } finally {
            session.close();
        }
    }

    public long countDocumentsByDossier(int dossierId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(d) FROM MedicalDocument d " +
                "WHERE d.dossierMedical.id = :dossierId", 
                Long.class
            );
            query.setParameter("dossierId", dossierId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }
}
