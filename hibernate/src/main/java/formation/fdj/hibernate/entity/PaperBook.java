package formation.fdj.hibernate.entity;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("paperbook")
public class PaperBook extends Book {
}
