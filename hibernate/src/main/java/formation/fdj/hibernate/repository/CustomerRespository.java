package formation.fdj.hibernate.repository;

import formation.fdj.hibernate.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface CustomerRespository extends JpaRepository<Customer, Long> {
    @Transactional(readOnly = true)
    @Query(value = "SELECT c from Customer c JOIN FETCH c.addresses where c.name = ?1")
    Customer fetchCustomerWithCustomerName(String name);
}
