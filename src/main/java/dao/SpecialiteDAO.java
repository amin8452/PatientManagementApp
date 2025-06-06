package dao;

import model.Specialite;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import utils.HibernateUtil;

import java.util.List;

public class SpecialiteDAO {

    public void save(Specialite specialite) {
        EntityManager em = HibernateUtil.getEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            em.persist(specialite);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Specialite findById(int id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.find(Specialite.class, id);
        } finally {
            em.close();
        }
    }

    public List<Specialite> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Specialite> query = em.createQuery("SELECT s FROM Specialite s", Specialite.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Specialite specialite) {
        EntityManager em = HibernateUtil.getEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            em.merge(specialite);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(Specialite specialite) {
        EntityManager em = HibernateUtil.getEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            if (em.contains(specialite)) {
                em.remove(specialite);
            } else {
                em.remove(em.merge(specialite));
            }
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Specialite findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Specialite> query = em.createQuery("SELECT s FROM Specialite s WHERE s.nom = :nom", Specialite.class);
            query.setParameter("nom", nom);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}