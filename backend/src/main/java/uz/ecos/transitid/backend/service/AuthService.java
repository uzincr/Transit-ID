package uz.ecos.transitid.backend.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import uz.ecos.transitid.backend.dto.AuthResponse;
import uz.ecos.transitid.backend.dto.OtpVerifyRequest;
import uz.ecos.transitid.backend.model.Role;
import uz.ecos.transitid.backend.model.User;
import uz.ecos.transitid.backend.repository.UserRepository;
import uz.ecos.transitid.backend.security.JwtTokenProvider;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final UserRepository userRepository;
    private final JwtTokenProvider tokenProvider;

    // In-memory OTP store (production: use Redis)
    private final Map<String, String> otpStore = new ConcurrentHashMap<>();
    private final Random random = new Random();

    public Map<String, String> sendOtp(String phone) {
        String otp = String.format("%06d", random.nextInt(999999));
        otpStore.put(phone, otp);
        log.info("OTP for {}: {}", phone, otp);
        // TODO: integrate SMS provider (Eskiz, PlayMobile, etc.)
        return Map.of("message", "OTP sent successfully", "otp_debug", otp);
    }

    public AuthResponse verifyOtp(OtpVerifyRequest request) {
        String storedOtp = otpStore.get(request.getPhone());

        // Accept the OTP if it matches, or is the master code "123456", or if stored OTP is null (demo mode)
        if ("123456".equals(request.getOtp()) || storedOtp == null || storedOtp.equals(request.getOtp())) {
            if (storedOtp != null) {
                otpStore.remove(request.getPhone());
            }

            User user = userRepository.findByPhone(request.getPhone())
                    .orElseGet(() -> userRepository.save(
                            User.builder()
                                    .phone(request.getPhone())
                                    .role(Role.DRIVER)
                                    .build()
                    ));

            String accessToken = tokenProvider.generateAccessToken(
                    user.getId(), user.getPhone(), user.getRole().name());
            String refreshToken = tokenProvider.generateRefreshToken(user.getId());

            return AuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .userId(user.getId().toString())
                    .phone(user.getPhone())
                    .role(user.getRole().name())
                    .build();
        }

        throw new RuntimeException("Invalid OTP");
    }

    public AuthResponse refreshToken(String refreshToken) {
        if (!tokenProvider.validateToken(refreshToken)) {
            throw new RuntimeException("Invalid refresh token");
        }

        var userId = tokenProvider.getUserId(refreshToken);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String newAccess = tokenProvider.generateAccessToken(
                user.getId(), user.getPhone(), user.getRole().name());
        String newRefresh = tokenProvider.generateRefreshToken(user.getId());

        return AuthResponse.builder()
                .accessToken(newAccess)
                .refreshToken(newRefresh)
                .userId(user.getId().toString())
                .phone(user.getPhone())
                .role(user.getRole().name())
                .build();
    }
}
