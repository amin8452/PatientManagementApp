package dao;

import model.Appointment;
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

public class AppointmentDAO {
    public void save(Appointment rendezVous) {
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

    public void update(Appointment rendezVous) {
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

    public void delete(Appointment rendezVous) {
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

    public Appointment findById(int id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            return session.get(Appointment.class, id);
        } finally {
            session.close();
        }
    }

    public List<Appointment> findAll() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery("FROM Appointment", Appointment.class);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery("FROM Appointment WHERE medecin.id = :medecinId", Appointment.class);
            query.setParameter("medecinId", medecinId);
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery("FROM Appointment WHERE patient.id = :patientId", Appointment.class);
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
                "SELECT COUNT(r) FROM Appointment r " +
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

    public List<Appointment> findByMedecinAndDate(int medecinId, Date date) {
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

            Query<Appointment> query = session.createQuery(
                "FROM Appointment r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure BETWEEN :startOfDay AND :endOfDay " +
                "ORDER BY r.dateHeure ASC", 
                Appointment.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("startOfDay", startOfDay);
            query.setParameter("endOfDay", endOfDay);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findByMedecinAndStatus(int medecinId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.statut = :status " +
                "ORDER BY r.dateHeure ASC", 
                Appointment.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("status", status);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findByPatientAndStatus(int patientId, String status) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment r " +
                "WHERE r.patient.id = :patientId " +
                "AND r.statut = :status " +
                "ORDER BY r.dateHeure ASC", 
                Appointment.class
            );
            
            query.setParameter("patientId", patientId);
            query.setParameter("status", status);
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findUpcomingByMedecin(int medecinId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment r " +
                "WHERE r.medecin.id = :medecinId " +
                "AND r.dateHeure > :now " +
                "AND r.statut = 'accepté' " +
                "ORDER BY r.dateHeure ASC", 
                Appointment.class
            );
            
            query.setParameter("medecinId", medecinId);
            query.setParameter("now", new Date());
            
            return query.list();
        } finally {
            session.close();
        }
    }

    public List<Appointment> findUpcomingByPatient(int patientId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        try {
            Query<Appointment> query = session.createQuery(
                "FROM Appointment r " +
                "WHERE r.patient.id = :patientId " +
                "AND r.dateHeure > :now " +
                "AND r.statut = 'accepté' " +
                "ORDER BY r.dateHeure ASC", 
                Appointment.class
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
                "SELECT COUNT(r) FROM Appointment r " +
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

    public long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery("SELECT COUNT(r) FROM Appointment r", Long.class);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
