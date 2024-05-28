package formation.fdj.hibernate.impl;

import org.springframework.data.jpa.repository.JpaRepository;

public interface BatchRepository<T, V> extends JpaRepository<T, V> {

    <S extends T> void saveInBatch(Iterable<S> entities);
}
