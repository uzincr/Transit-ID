package uz.ecos.transitid.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;

@Data
@Builder
@AllArgsConstructor
public class LicenseResponse {
    private String id;
    private String licenseNumber;
    private String driverName;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    private String status;
    private long daysRemaining;
}
