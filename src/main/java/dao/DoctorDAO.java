package dao;

import model.Doctor;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class DoctorDAO {
    public void save(Doctor medecin) {
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

    public void update(Doctor medecin) {
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

    public void delete(Doctor medecin) {
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

    public Doctor findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(Doctor.class, id);
        } finally {
            session.close();
        }
    }

    public List<Doctor> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Doctor> query = session.createQuery("FROM Doctor", Doctor.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public Doctor findByUtilisateur(int utilisateurId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Doctor> query = session.createQuery("FROM Doctor WHERE utilisateur.id = :utilisateurId", Doctor.class);
            query.setParameter("utilisateurId", utilisateurId);
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(m) FROM Doctor m", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
