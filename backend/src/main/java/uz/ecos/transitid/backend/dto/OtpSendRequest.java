package uz.ecos.transitid.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class OtpSendRequest {
    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^\\+998\\d{9}$", message = "Invalid Uzbek phone format")
    private String phone;
}
