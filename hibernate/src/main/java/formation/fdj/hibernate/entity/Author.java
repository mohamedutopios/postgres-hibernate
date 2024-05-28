package formation.fdj.hibernate.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Author {
    @Id

    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "")
    //GenericGenerator(name ="", strategy="", parameters={})
    private Long id;


}
