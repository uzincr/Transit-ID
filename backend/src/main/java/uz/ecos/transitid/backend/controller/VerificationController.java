package uz.ecos.transitid.backend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import uz.ecos.transitid.backend.dto.LicenseResponse;
import uz.ecos.transitid.backend.service.LicenseService;

@RestController
@RequestMapping("/api/verify")
@RequiredArgsConstructor
public class VerificationController {

    private final LicenseService licenseService;

    /**
     * Public endpoint for GAI verification via QR code or license number.
     * Returns driver name, license number, expiry date, and status.
     */
    @GetMapping("/license/{licenseNumber}")
    public ResponseEntity<LicenseResponse> verifyLicense(@PathVariable String licenseNumber) {
        return ResponseEntity.ok(licenseService.getByLicenseNumber(licenseNumber));
    }
}
