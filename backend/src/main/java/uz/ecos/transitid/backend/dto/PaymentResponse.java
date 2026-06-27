package uz.ecos.transitid.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentResponse {
    private String id;
    private String userId;
    private String userName;
    private BigDecimal amount;
    private String method;
    private String status;
    private String description;
    private LocalDateTime createdAt;
}
