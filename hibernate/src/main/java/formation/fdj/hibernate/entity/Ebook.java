package formation.fdj.hibernate.entity;

import org.hibernate.annotations.Polymorphism;
import org.hibernate.annotations.PolymorphismType;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;

@Entity
@DiscriminatorValue("ebook")
@PrimaryKeyJoinColumn(name= "ebook_id")
@Polymorphism(type = PolymorphismType.EXPLICIT)
public class Ebook extends Book{
}
