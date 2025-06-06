package dao;

import model.Medecin;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class MedecinDAO {
    public void save(Medecin medecin) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(medecin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void update(Medecin medecin) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(medecin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void delete(Medecin medecin) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(medecin);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public Medecin findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(Medecin.class, id);
        } finally {
            session.close();
        }
    }

    public List<Medecin> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Medecin> query = session.createQuery("FROM Medecin", Medecin.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public Medecin findByUtilisateur(int utilisateurId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Medecin> query = session.createQuery("FROM Medecin WHERE utilisateur.id = :utilisateurId", Medecin.class);
            query.setParameter("utilisateurId", utilisateurId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(m) FROM Medecin m", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
