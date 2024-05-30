package formation.fdj.hibernate.service;

import formation.fdj.hibernate.entity.Author;
import formation.fdj.hibernate.entity.Book;
import formation.fdj.hibernate.repository.AuthorRepository;
import formation.fdj.hibernate.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityGraph;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class BookService {

    @PersistenceContext
    EntityManager entityManager;

    @Autowired
    BookRepository bookRepository;

    @Autowired
    AuthorRepository authorRepository;

    @Transactional
    public void save(Book book) {
        Author author = authorRepository.findById(1L).orElse(null);
        if (author != null) {
            book.addAuthor(author);
        }
        bookRepository.save(book);
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "books", key = "#name")
    public List<Book> getBooksByName(String name) {
        return bookRepository.findByName(name);
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "books", key = "#id")
    public Book getProduct(Long id) {
        return bookRepository.findById(id).orElse(null);
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
