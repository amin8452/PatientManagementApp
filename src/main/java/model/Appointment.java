package model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "rendezvous")
public class Appointment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "medecin_id")
    private Doctor medecin;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dateHeure;

    private String statut; // accepté, refusé, en attente

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Doctor getMedecin() { return medecin; }
    public void setMedecin(Doctor medecin) { this.medecin = medecin; }

    public Date getDateHeure() { return dateHeure; }
    public void setDateHeure(Date dateHeure) { this.dateHeure = dateHeure; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
}
