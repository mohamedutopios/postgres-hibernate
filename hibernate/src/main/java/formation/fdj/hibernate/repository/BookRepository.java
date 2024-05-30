package formation.fdj.hibernate.repository;

import formation.fdj.hibernate.entity.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {
    // Déclarez la méthode de recherche par nom
    List<Book> findByName(String name);
}
