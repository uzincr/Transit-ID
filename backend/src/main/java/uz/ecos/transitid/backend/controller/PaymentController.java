package uz.ecos.transitid.backend.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import uz.ecos.transitid.backend.dto.PaymentRequest;
import uz.ecos.transitid.backend.dto.PaymentResponse;
import uz.ecos.transitid.backend.service.PaymentService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping
    public ResponseEntity<PaymentResponse> createPayment(Authentication auth, @Valid @RequestBody PaymentRequest request) {
        UUID userId = UUID.fromString(auth.getName());
        return ResponseEntity.ok(paymentService.createPayment(userId, request));
    }

    @PostMapping("/{id}/complete")
    public ResponseEntity<PaymentResponse> completePayment(@PathVariable UUID id, @RequestParam boolean success) {
        return ResponseEntity.ok(paymentService.completePayment(id, success));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PaymentResponse> getPaymentById(@PathVariable UUID id) {
        return ResponseEntity.ok(paymentService.getById(id));
    }

    @GetMapping
    public ResponseEntity<List<PaymentResponse>> getPayments(Authentication auth) {
        UUID userId = UUID.fromString(auth.getName());
        // For admin, return all payments. For drivers, return user's payments.
        boolean isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            return ResponseEntity.ok(paymentService.getAll());
        } else {
            return ResponseEntity.ok(paymentService.getByUserId(userId));
        }
    }
}
