package dao;

import model.DossierMedical;
import model.DocumentMedical;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import java.util.Date;

public class DossierMedicalDAO {
    public void save(DossierMedical dossier) {
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

    public void update(DossierMedical dossier) {
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

    public void delete(DossierMedical dossier) {
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

    public DossierMedical findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(DossierMedical.class, id);
        } finally {
            session.close();
        }
    }

    public List<DossierMedical> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DossierMedical> query = session.createQuery("FROM DossierMedical", DossierMedical.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public DocumentMedical findDocumentById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(DocumentMedical.class, id);
        } finally {
            session.close();
        }
    }

    public void addDocument(DocumentMedical document) {
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

    public List<DossierMedical> findByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DossierMedical> query = session.createQuery("FROM DossierMedical WHERE medecin.id = :medecinId", DossierMedical.class);
            query.setParameter("medecinId", medecinId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public DossierMedical findByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DossierMedical> query = session.createQuery("FROM DossierMedical WHERE patient.id = :patientId", DossierMedical.class);
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
                "SELECT COUNT(d) FROM DossierMedical d " +
                "WHERE d.medecin.id = :medecinId", 
                Long.class
            );
            query.setParameter("medecinId", medecinId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public List<DossierMedical> findByMedecinAndDateRange(int medecinId, Date startDate, Date endDate) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DossierMedical> query = session.createQuery(
                "FROM DossierMedical d " +
                "WHERE d.medecin.id = :medecinId " +
                "AND d.lastUpdate BETWEEN :startDate AND :endDate " +
                "ORDER BY d.lastUpdate DESC", 
                DossierMedical.class
            );
            query.setParameter("medecinId", medecinId);
            query.setParameter("startDate", startDate);
            query.setParameter("endDate", endDate);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<DocumentMedical> findDocumentsByDossier(int dossierId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DocumentMedical> query = session.createQuery(
                "FROM DocumentMedical d " +
                "WHERE d.dossierMedical.id = :dossierId " +
                "ORDER BY d.dateAjout DESC", 
                DocumentMedical.class
            );
            query.setParameter("dossierId", dossierId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<DocumentMedical> findDocumentsByType(int dossierId, String type) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DocumentMedical> query = session.createQuery(
                "FROM DocumentMedical d " +
                "WHERE d.dossierMedical.id = :dossierId " +
                "AND d.type = :type " +
                "ORDER BY d.dateAjout DESC", 
                DocumentMedical.class
            );
            query.setParameter("dossierId", dossierId);
            query.setParameter("type", type);
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
            DocumentMedical document = session.get(DocumentMedical.class, documentId);
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

    public List<DossierMedical> findRecentlyUpdated(int limit) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<DossierMedical> query = session.createQuery(
                "FROM DossierMedical d " +
                "ORDER BY d.lastUpdate DESC", 
                DossierMedical.class
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
                "SELECT COUNT(d) FROM DocumentMedical d " +
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
