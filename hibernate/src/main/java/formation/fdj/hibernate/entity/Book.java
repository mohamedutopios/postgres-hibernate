package formation.fdj.hibernate.entity;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;



@NamedEntityGraph(
        name = "graph-author",
        attributeNodes = {
                @NamedAttributeNode("authors")
        }
)
@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
@DynamicUpdate
@Cacheable
@Cache(usage= CacheConcurrencyStrategy.READ_WRITE)
public class Book {

    @Id
    private Long id;

    private String title;

    @Column(insertable = false, updatable = false)
    private Date date_add;

    @Cacheable
    @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
    @OneToMany
    private List<Author> authors;

    public Book() {
        authors = new ArrayList<>();
    }
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public List<Author> getAuthors() {
        return authors;
    }

    public void setAuthors(List<Author> authors) {
        this.authors = authors;
    }

    public void addAuthor(Author a) {
        authors.add(a);
    }
}
