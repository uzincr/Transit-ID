package uz.ecos.transitid.backend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import uz.ecos.transitid.backend.model.DriverProfile;
import uz.ecos.transitid.backend.model.User;
import uz.ecos.transitid.backend.repository.DriverProfileRepository;
import uz.ecos.transitid.backend.repository.UserRepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;
    private final DriverProfileRepository driverProfileRepository;

    @GetMapping
    public ResponseEntity<?> getAllUsers() {
        List<User> users = userRepository.findAll();
        List<Map<String, Object>> response = new ArrayList<>();

        for (User u : users) {
            DriverProfile profile = driverProfileRepository.findByUserId(u.getId()).orElse(null);
            Map<String, Object> map = new HashMap<>();
            map.put("id", u.getId().toString());
            map.put("phone", u.getPhone());
            map.put("role", u.getRole().name());
            map.put("fullName", profile != null ? profile.getFullName() : (u.getFullName() != null ? u.getFullName() : ""));
            map.put("createdAt", u.getCreatedAt().toString());

            if (profile != null) {
                map.put("carBrand", profile.getCarBrand() != null ? profile.getCarBrand() : "");
                map.put("carNumber", profile.getCarNumber() != null ? profile.getCarNumber() : "");
                map.put("licenseClass", profile.getLicenseClass() != null ? profile.getLicenseClass() : "");
            } else {
                map.put("carBrand", "");
                map.put("carNumber", "");
                map.put("licenseClass", "");
            }
            response.add(map);
        }

        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<?> getMe(Authentication auth) {
        UUID userId = UUID.fromString(auth.getName());
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        DriverProfile profile = driverProfileRepository.findByUserId(userId).orElse(null);

        Map<String, Object> response = new HashMap<>();
        response.put("id", user.getId().toString());
        response.put("phone", user.getPhone());
        response.put("role", user.getRole().name());
        response.put("fullName", profile != null ? profile.getFullName() : (user.getFullName() != null ? user.getFullName() : ""));
        response.put("createdAt", user.getCreatedAt().toString());

        if (profile != null) {
            response.put("carBrand", profile.getCarBrand() != null ? profile.getCarBrand() : "");
            response.put("carNumber", profile.getCarNumber() != null ? profile.getCarNumber() : "");
            response.put("licenseClass", profile.getLicenseClass() != null ? profile.getLicenseClass() : "");
        } else {
            response.put("carBrand", "");
            response.put("carNumber", "");
            response.put("licenseClass", "");
        }

        return ResponseEntity.ok(response);
    }
}
