package uz.ecos.transitid.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import uz.ecos.transitid.backend.model.DriverProfile;
import uz.ecos.transitid.backend.model.User;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface DriverProfileRepository extends JpaRepository<DriverProfile, UUID> {
    Optional<DriverProfile> findByUser(User user);
    Optional<DriverProfile> findByUserId(UUID userId);
}
