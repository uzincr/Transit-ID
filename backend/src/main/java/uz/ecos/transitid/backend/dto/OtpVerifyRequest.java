package uz.ecos.transitid.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class OtpVerifyRequest {
    @NotBlank
    private String phone;

    @NotBlank
    @Size(min = 6, max = 6)
    private String otp;
}
