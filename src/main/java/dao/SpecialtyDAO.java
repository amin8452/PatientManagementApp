package dao;

import model.Specialty;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;
import utils.HibernateUtil;

import java.util.List;

public class SpecialtyDAO {

    public void save(Specialty specialite) {
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

    public Specialty findById(int id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.find(Specialty.class, id);
        } finally {
            em.close();
        }
    }

    public List<Specialty> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Specialty> query = em.createQuery("SELECT s FROM Specialty s", Specialty.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Specialty specialite) {
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

    public void delete(Specialty specialite) {
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

    public Specialty findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Specialty> query = em.createQuery("SELECT s FROM Specialty s WHERE s.nom = :nom", Specialty.class);
            query.setParameter("nom", nom);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }
}
