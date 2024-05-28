package formation.fdj.hibernate.service;

import formation.fdj.hibernate.entity.Author;
import formation.fdj.hibernate.entity.Book;
import formation.fdj.hibernate.repository.AuthorRepository;
import formation.fdj.hibernate.repository.BookRepository;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityGraph;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class BookService {

    @PersistenceContext
    EntityManager entityManager;
    BookRepository bookRepository;
    AuthorRepository authorRepository;
    public void save(Book book) {
        var author = authorRepository.findById(1L);
    }
    public void batchBooksAndAuthors() {
        List<Book> books = new ArrayList<>();
        for(int i=1; i <= 10; i++) {
            Book b = new Book();
            for(int j=1; j < 10; j++) {
                b.addAuthor(new Author());
            }
        }
        authorRepository.saveInBatch(books);
    }

    public void findByGraph() {
        EntityGraph graph = entityManager.getEntityGraph("graph-author");
        HashMap<String, Object> props = new HashMap<>();
        props.put("javax.persistence.fetchgraph", graph);
        Book book = entityManager.find(Book.class, 1, props);

    }

}
