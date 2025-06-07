package model;

import javax.persistence.*;

@Entity
@Table(name = "document_medical")
public class MedicalDocument {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String nom;
    private String cheminFichier;

    @ManyToOne
    @JoinColumn(name = "dossier_medical_id")
    private MedicalRecord dossierMedical;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }

    public MedicalRecord getDossierMedical() { return dossierMedical; }
    public void setDossierMedical(MedicalRecord dossierMedical) { this.dossierMedical = dossierMedical; }
}
