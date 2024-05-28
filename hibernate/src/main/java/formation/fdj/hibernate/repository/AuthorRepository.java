package formation.fdj.hibernate.repository;

import formation.fdj.hibernate.entity.Author;
import formation.fdj.hibernate.impl.BatchRepository;
import formation.fdj.hibernate.projection.SimpleAuthor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface AuthorRepository extends BatchRepository<Author, Long> {

    @Transactional(readOnly = true)
    List<SimpleAuthor> findAllById(int id);
}
