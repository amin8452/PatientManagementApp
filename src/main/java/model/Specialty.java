package model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "specialite")
public class Specialty {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, unique = true)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @OneToMany(mappedBy = "specialite", cascade = CascadeType.ALL)
    private List<Doctor> medecins;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Doctor> getMedecins() { return medecins; }
    public void setMedecins(List<Doctor> medecins) { this.medecins = medecins; }
}
