package dao;

import model.RendezVous;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import utils.HibernateUtil;
import java.util.List;
import java.util.Date;
import java.util.Calendar;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.NoResultException;
import javax.persistence.TypedQuery;

public class RendezVousDAO {
    public void save(RendezVous rendezVous) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.save(rendezVous);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void update(RendezVous rendezVous) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.update(rendezVous);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void delete(RendezVous rendezVous) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            session.delete(rendezVous);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public RendezVous findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(RendezVous.class, id);
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery("FROM RendezVous", RendezVous.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery("FROM RendezVous WHERE medecin.id = :medecinId", RendezVous.class);
            query.setParameter("medecinId", medecinId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery("FROM RendezVous WHERE patient.id = :patientId", RendezVous.class);
            query.setParameter("patientId", patientId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public long countByMedecinAndDate(int medecinId, Date date) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Create calendar instances for start and end of the day
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            Date startOfDay = calendar.getTime();

            calendar.set(Calendar.HOUR_OF_DAY, 23);
            calendar.set(Calendar.MINUTE, 59);
            calendar.set(Calendar.SECOND, 59);
            calendar.set(Calendar.MILLISECOND, 999);
            Date endOfDay = calendar.getTime();

            // Create and execute the query
            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure BETWEEN :startOfDay AND :endOfDay", 
                Long.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("endOfDay", endOfDay);
            
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findByMedecinAndDate(int medecinId, Date date) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            Date startOfDay = calendar.getTime();

            calendar.set(Calendar.HOUR_OF_DAY, 23);
            calendar.set(Calendar.MINUTE, 59);
            calendar.set(Calendar.SECOND, 59);
            calendar.set(Calendar.MILLISECOND, 999);
            Date endOfDay = calendar.getTime();

            Query<RendezVous> query = session.createQuery(
                "FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure BETWEEN :startOfDay AND :endOfDay " +
                "ORDER BY r.dateHeure ASC", 
                RendezVous.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("endOfDay", endOfDay);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findByMedecinAndStatus(int medecinId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery(
                "FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.statut = :status " +
                "ORDER BY r.dateHeure ASC", 
                RendezVous.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("status", status);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findByPatientAndStatus(int patientId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery(
                "FROM RendezVous r " +
                "WHERE r.patient.id = :patientId " +
                "AND r.statut = :status " +
                "ORDER BY r.dateHeure ASC", 
                RendezVous.class
            );
            
            query.setParameter("patientId", patientId);
            query.setParameter("status", status);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findUpcomingByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery(
                "FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure > :now " +
                "AND r.statut = 'accepté' " +
                "ORDER BY r.dateHeure ASC", 
                RendezVous.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("now", new Date());
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<RendezVous> findUpcomingByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<RendezVous> query = session.createQuery(
                "FROM RendezVous r " +
                "WHERE r.patient.id = :patientId " +
                "AND r.dateHeure > :now " +
                "AND r.statut = 'accepté' " +
                "ORDER BY r.dateHeure ASC", 
                RendezVous.class
            );
            
            query.setParameter("patientId", patientId);
            query.setParameter("now", new Date());
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public long countByMedecinAndStatus(int medecinId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.statut = :status", 
                Long.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("status", status);
            
            return query.uniqueResult();
        } finally {
            session.close();
        }
    }

    public boolean isTimeSlotAvailable(int medecinId, Date dateTime) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            // Create a 30-minute window around the requested time
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(dateTime);
            calendar.add(Calendar.MINUTE, -15);
            Date startWindow = calendar.getTime();
            
            calendar.setTime(dateTime);
            calendar.add(Calendar.MINUTE, 15);
            Date endWindow = calendar.getTime();

            Query<Long> query = session.createQuery(
                "SELECT COUNT(r) FROM RendezVous r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure BETWEEN :startWindow AND :endWindow " +
                "AND r.statut != 'refusé'", 
                Long.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("startWindow", startWindow);
            query.setParameter("endWindow", endWindow);
            
            return query.uniqueResult() == 0;
        } finally {
            session.close();
        }
    }

    public long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(r) FROM RendezVous r", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
