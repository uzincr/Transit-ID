package uz.ecos.transitid.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import uz.ecos.transitid.backend.model.DriverProfile;
import uz.ecos.transitid.backend.model.License;
import uz.ecos.transitid.backend.model.LicenseStatus;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface LicenseRepository extends JpaRepository<License, UUID> {
    List<License> findByDriver(DriverProfile driver);
    List<License> findByDriverId(UUID driverId);
    Optional<License> findByLicenseNumber(String licenseNumber);
    List<License> findByStatus(LicenseStatus status);
    List<License> findByExpiryDateBetween(LocalDate from, LocalDate to);
}
