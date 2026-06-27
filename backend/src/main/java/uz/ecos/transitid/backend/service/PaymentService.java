package uz.ecos.transitid.backend.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import uz.ecos.transitid.backend.dto.PaymentRequest;
import uz.ecos.transitid.backend.dto.PaymentResponse;
import uz.ecos.transitid.backend.model.*;
import uz.ecos.transitid.backend.repository.DriverProfileRepository;
import uz.ecos.transitid.backend.repository.PaymentRepository;
import uz.ecos.transitid.backend.repository.UserRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final UserRepository userRepository;
    private final DriverProfileRepository driverProfileRepository;
    private final LicenseService licenseService;

    public List<PaymentResponse> getByUserId(UUID userId) {
        return paymentRepository.findByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(this::toResponse)
                .toList();
    }

    public PaymentResponse getById(UUID id) {
        Payment payment = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment not found"));
        return toResponse(payment);
    }

    public List<PaymentResponse> getAll() {
        return paymentRepository.findAll().stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public PaymentResponse createPayment(UUID userId, PaymentRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Payment payment = Payment.builder()
                .user(user)
                .amount(request.getAmount())
                .method(request.getMethod())
                .status(PaymentStatus.PENDING)
                .description(request.getDescription())
                .build();

        payment = paymentRepository.save(payment);
        return toResponse(payment);
    }

    @Transactional
    public PaymentResponse completePayment(UUID paymentId, boolean success) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new RuntimeException("Payment not found"));

        if (payment.getStatus() != PaymentStatus.PENDING) {
            throw new RuntimeException("Payment is already processed");
        }

        if (success) {
            payment.setStatus(PaymentStatus.SUCCESS);
            // Business Logic: payment success -> renew license
            licenseService.renewLicenseForUser(payment.getUser().getId());
        } else {
            payment.setStatus(PaymentStatus.FAILED);
        }

        payment = paymentRepository.save(payment);
        return toResponse(payment);
    }

    private PaymentResponse toResponse(Payment p) {
        String fullName = "";
        DriverProfile dp = driverProfileRepository.findByUserId(p.getUser().getId()).orElse(null);
        if (dp != null) {
            fullName = dp.getFullName();
        } else if (p.getUser().getFullName() != null) {
            fullName = p.getUser().getFullName();
        }

        return PaymentResponse.builder()
                .id(p.getId().toString())
                .userId(p.getUser().getId().toString())
                .userName(fullName)
                .amount(p.getAmount())
                .method(p.getMethod())
                .status(p.getStatus().name())
                .description(p.getDescription())
                .createdAt(p.getCreatedAt())
                .build();
    }
}
