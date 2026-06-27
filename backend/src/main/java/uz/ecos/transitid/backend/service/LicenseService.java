package uz.ecos.transitid.backend.service;

import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uz.ecos.transitid.backend.dto.LicenseCreateRequest;
import uz.ecos.transitid.backend.dto.LicenseResponse;
import uz.ecos.transitid.backend.dto.LicenseUpdateRequest;
import uz.ecos.transitid.backend.model.DriverProfile;
import uz.ecos.transitid.backend.model.License;
import uz.ecos.transitid.backend.model.LicenseStatus;
import uz.ecos.transitid.backend.model.User;
import uz.ecos.transitid.backend.repository.DriverProfileRepository;
import uz.ecos.transitid.backend.repository.LicenseRepository;
import uz.ecos.transitid.backend.repository.UserRepository;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LicenseService {

    private final LicenseRepository licenseRepository;
    private final DriverProfileRepository driverProfileRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;
    private final Random random = new Random();

    public List<LicenseResponse> getByDriverId(UUID driverId) {
        return licenseRepository.findByDriverId(driverId).stream()
                .map(this::toResponse)
                .toList();
    }

    public List<LicenseResponse> getByUserId(UUID userId) {
        DriverProfile profile = driverProfileRepository.findByUserId(userId).orElse(null);
        if (profile == null) {
            return List.of();
        }
        return licenseRepository.findByDriverId(profile.getId()).stream()
                .map(this::toResponse)
                .toList();
    }

    public LicenseResponse getByLicenseNumber(String number) {
        License lic = licenseRepository.findByLicenseNumber(number)
                .orElseThrow(() -> new RuntimeException("License not found: " + number));
        return toResponse(lic);
    }

    public LicenseResponse getById(UUID id) {
        License lic = licenseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("License not found"));
        return toResponse(lic);
    }

    public List<LicenseResponse> getAll() {
        return licenseRepository.findAll().stream()
                .map(this::toResponse)
                .toList();
    }

    public List<LicenseResponse> getExpiring() {
        LocalDate now = LocalDate.now();
        return licenseRepository.findByExpiryDateBetween(now, now.plusDays(15)).stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public void renewLicenseForUser(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));

        DriverProfile driver = driverProfileRepository.findByUserId(userId)
                .orElseGet(() -> driverProfileRepository.save(
                        DriverProfile.builder()
                                .user(user)
                                .fullName(user.getFullName() != null ? user.getFullName() : "Haydovchi " + user.getPhone())
                                .carBrand("Chevrolet Cobalt")
                                .carNumber("01A777AA")
                                .licenseClass("B")
                                .build()
                ));

        // Mark existing ACTIVE or EXPIRING licenses as RENEWED
        List<License> activeLicenses = licenseRepository.findByDriverId(driver.getId());
        for (License active : activeLicenses) {
            if (active.getStatus() == LicenseStatus.ACTIVE || active.getStatus() == LicenseStatus.EXPIRING) {
                active.setStatus(LicenseStatus.RENEWED);
                licenseRepository.save(active);
            }
        }

        // Create new license
        String licenseNum = "TID-" + String.format("%07d", random.nextInt(10000000));
        License newLicense = License.builder()
                .driver(driver)
                .licenseNumber(licenseNum)
                .issueDate(LocalDate.now())
                .expiryDate(LocalDate.now().plusYears(1))
                .status(LicenseStatus.ACTIVE)
                .build();

        licenseRepository.save(newLicense);

        // Send confirmation notification
        notificationService.createNotification(user, "Litsenziya yangilandi", 
                "Sizning yangi litsenziyangiz muvaffaqiyatli yaratildi. Raqam: " + licenseNum);
    }

    @Transactional
    public LicenseResponse createLicense(LicenseCreateRequest request) {
        UUID driverUserId = UUID.fromString(request.getDriverUserId());
        User user = userRepository.findById(driverUserId)
                .orElseThrow(() -> new RuntimeException("Driver user not found"));

        DriverProfile driver = driverProfileRepository.findByUserId(driverUserId)
                .orElseGet(() -> driverProfileRepository.save(
                        DriverProfile.builder()
                                .user(user)
                                .fullName(user.getFullName() != null ? user.getFullName() : "Haydovchi " + user.getPhone())
                                .carBrand("Unknown")
                                .carNumber("000")
                                .licenseClass("B")
                                .build()
                ));

        License license = License.builder()
                .driver(driver)
                .licenseNumber(request.getLicenseNumber())
                .issueDate(request.getIssueDate())
                .expiryDate(request.getExpiryDate())
                .status(LicenseStatus.valueOf(request.getStatus()))
                .build();

        license = licenseRepository.save(license);
        return toResponse(license);
    }

    @Transactional
    public LicenseResponse updateLicense(UUID id, LicenseUpdateRequest request) {
        License license = licenseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("License not found"));

        if (request.getLicenseNumber() != null) {
            license.setLicenseNumber(request.getLicenseNumber());
        }
        if (request.getIssueDate() != null) {
            license.setIssueDate(request.getIssueDate());
        }
        if (request.getExpiryDate() != null) {
            license.setExpiryDate(request.getExpiryDate());
        }
        if (request.getStatus() != null) {
            license.setStatus(LicenseStatus.valueOf(request.getStatus()));
        }

        license = licenseRepository.save(license);
        return toResponse(license);
    }

    // Scheduled task: update license statuses daily at midnight
    @Scheduled(cron = "0 0 0 * * ?")
    public void updateLicenseStatuses() {
        LocalDate today = LocalDate.now();
        List<License> all = licenseRepository.findAll();

        for (License lic : all) {
            if (lic.getStatus() == LicenseStatus.RENEWED) continue;

            long daysUntilExpiry = ChronoUnit.DAYS.between(today, lic.getExpiryDate());

            LicenseStatus oldStatus = lic.getStatus();
            LicenseStatus newStatus;

            if (daysUntilExpiry < 0) {
                newStatus = LicenseStatus.EXPIRED;
            } else if (daysUntilExpiry <= 15) {
                newStatus = LicenseStatus.EXPIRING;
            } else {
                newStatus = LicenseStatus.ACTIVE;
            }

            if (oldStatus != newStatus) {
                lic.setStatus(newStatus);
                // Send notification on status change to EXPIRING or EXPIRED
                if (newStatus == LicenseStatus.EXPIRING) {
                    notificationService.createNotification(lic.getDriver().getUser(), 
                            "Litsenziya muddati tugamoqda", 
                            "Sizning " + lic.getLicenseNumber() + " raqamli litsenziyangiz muddati " + daysUntilExpiry + " kundan keyin tugaydi. Iltimos to'lov qiling.");
                } else if (newStatus == LicenseStatus.EXPIRED) {
                    notificationService.createNotification(lic.getDriver().getUser(), 
                            "Litsenziya muddati tugadi", 
                            "Sizning " + lic.getLicenseNumber() + " raqamli litsenziyangiz muddati tugadi. Harakatlanish taqiqlanadi.");
                }
            }
        }

        licenseRepository.saveAll(all);
    }

    private LicenseResponse toResponse(License lic) {
        long days = ChronoUnit.DAYS.between(LocalDate.now(), lic.getExpiryDate());
        return LicenseResponse.builder()
                .id(lic.getId().toString())
                .licenseNumber(lic.getLicenseNumber())
                .driverName(lic.getDriver().getFullName())
                .issueDate(lic.getIssueDate())
                .expiryDate(lic.getExpiryDate())
                .status(lic.getStatus().name())
                .daysRemaining(Math.max(days, 0))
                .build();
    }
}
