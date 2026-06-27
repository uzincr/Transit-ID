package uz.ecos.transitid.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class LicenseCreateRequest {
    @NotNull(message = "Driver User ID is required")
    private String driverUserId;

    @NotBlank(message = "License number is required")
    private String licenseNumber;

    @NotNull(message = "Issue date is required")
    private LocalDate issueDate;

    @NotNull(message = "Expiry date is required")
    private LocalDate expiryDate;

    @NotBlank(message = "Status is required")
    private String status;
}
