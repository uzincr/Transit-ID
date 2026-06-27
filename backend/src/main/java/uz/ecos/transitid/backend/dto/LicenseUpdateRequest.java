package uz.ecos.transitid.backend.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class LicenseUpdateRequest {
    private String licenseNumber;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    private String status;
}
