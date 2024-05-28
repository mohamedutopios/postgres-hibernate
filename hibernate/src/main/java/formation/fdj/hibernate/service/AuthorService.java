package formation.fdj.hibernate.service;

import formation.fdj.hibernate.entity.Author;
import formation.fdj.hibernate.entity.Book;
import formation.fdj.hibernate.repository.AuthorRepository;
import org.hibernate.SQLQuery;
import org.hibernate.query.NativeQuery;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import java.util.Arrays;
import java.util.List;

import static com.vladmihalcea.sql.SQLStatementCountValidator.assertInsertCount;

public class AuthorService {

    @PersistenceContext
    EntityManager entityManager;
    AuthorRepository authorRepository;
    public void update() {
        //entityManager.createQuery("Update Book set title= 'new vaue'").executeUpdate();
        /*Query nativeQuery = entityManager.createNativeQuery("update book set title = 'newvalue'");
        nativeQuery.unwrap(NativeQuery.class).addSynchronizedEntityClass(Book.class);*/
    }

    public List get() {
        return entityManager.createQuery("SELECT b FROM Book b").setHint("javax.persistence.fetchgraph",entityManager.getEntityGraph("graph-author")).setHint("org.hibernate.cacheable", true).getResultList();
    }

    public void mockAuthors() {
        Author a1 = new Author();
        Author a2 = new Author();
        List<Author> as = Arrays.asList(a1, a2);
        authorRepository.saveAll(as);

        //Pour l'exemple l'utilisation des assert sur le nombre de requêtes
        assertInsertCount(4);
    }
}
