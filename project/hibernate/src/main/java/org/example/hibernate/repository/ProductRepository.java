package org.example.hibernate.repository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByName(String name);
}
