package formation.fdj.hibernate.repository;

import formation.fdj.hibernate.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface AddressRepository extends JpaRepository<Address, Long> {
    @Transactional(readOnly = true)
    @Query(value = "SELECT a from Address a JOIN FETCH a.customer where a.postCode = ?1")
    List<Address> fetchAdressesWithCustomerByPostCode(String postCode);
}
