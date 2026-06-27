package uz.ecos.transitid.backend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import uz.ecos.transitid.backend.dto.LicenseCreateRequest;
import uz.ecos.transitid.backend.dto.LicenseResponse;
import uz.ecos.transitid.backend.dto.LicenseUpdateRequest;
import uz.ecos.transitid.backend.service.LicenseService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/licenses")
@RequiredArgsConstructor
public class LicenseController {

    private final LicenseService licenseService;

    @GetMapping
    public ResponseEntity<List<LicenseResponse>> getAll() {
        return ResponseEntity.ok(licenseService.getAll());
    }

    @GetMapping("/my")
    public ResponseEntity<List<LicenseResponse>> getMyLicenses(Authentication auth) {
        UUID userId = UUID.fromString(auth.getName());
        return ResponseEntity.ok(licenseService.getByUserId(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<LicenseResponse> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(licenseService.getById(id));
    }

    @GetMapping("/number/{number}")
    public ResponseEntity<LicenseResponse> getByNumber(@PathVariable String number) {
        return ResponseEntity.ok(licenseService.getByLicenseNumber(number));
    }

    @GetMapping("/driver/{driverId}")
    public ResponseEntity<List<LicenseResponse>> getByDriver(@PathVariable UUID driverId) {
        return ResponseEntity.ok(licenseService.getByDriverId(driverId));
    }

    @GetMapping("/expiring")
    public ResponseEntity<List<LicenseResponse>> getExpiring() {
        return ResponseEntity.ok(licenseService.getExpiring());
    }

    @PostMapping
    public ResponseEntity<LicenseResponse> createLicense(@Valid @RequestBody LicenseCreateRequest request) {
        return ResponseEntity.ok(licenseService.createLicense(request));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<LicenseResponse> updateLicense(@PathVariable UUID id, @RequestBody LicenseUpdateRequest request) {
        return ResponseEntity.ok(licenseService.updateLicense(id, request));
    }
}
