package uz.ecos.transitid.backend.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import uz.ecos.transitid.backend.model.*;
import uz.ecos.transitid.backend.repository.DriverProfileRepository;
import uz.ecos.transitid.backend.repository.LicenseRepository;
import uz.ecos.transitid.backend.repository.PaymentRepository;
import uz.ecos.transitid.backend.repository.UserRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final DriverProfileRepository driverProfileRepository;
    private final LicenseRepository licenseRepository;
    private final PaymentRepository paymentRepository;
    private final NotificationService notificationService;

    @Override
    public void run(String... args) throws Exception {
        if (userRepository.count() == 0) {
            log.info("Ma'lumotlar bazasi bo'sh. Sinov ma'lumotlarini yuklash boshlandi...");

            // 1. Admin yaratish
            User admin = User.builder()
                    .phone("+998991234567")
                    .fullName("Tizim Admini")
                    .role(Role.ADMIN)
                    .build();
            userRepository.save(admin);
            log.info("Admin foydalanuvchisi yaratildi: {}", admin.getPhone());

            // 2. Driver foydalanuvchisi yaratish (Samuel R. Adams)
            User driverUser = User.builder()
                    .phone("+998997777777")
                    .fullName("Samuel R. Adams")
                    .role(Role.DRIVER)
                    .build();
            driverUser = userRepository.save(driverUser);
            log.info("Haydovchi foydalanuvchisi yaratildi: {}", driverUser.getPhone());

            // 3. Driver Profile yaratish
            DriverProfile driverProfile = DriverProfile.builder()
                    .user(driverUser)
                    .fullName("Samuel R. Adams")
                    .carBrand("Chevrolet Cobalt")
                    .carNumber("01A777AA")
                    .licenseClass("B, C")
                    .build();
            driverProfile = driverProfileRepository.save(driverProfile);
            log.info("Haydovchi profili yaratildi.");

            // 4. Muddati tugayotgan litsenziya yaratish (Muddati bugundan boshlab 10 kundan keyin tugaydi)
            License expiringLicense = License.builder()
                    .driver(driverProfile)
                    .licenseNumber("TID-8842109")
                    .issueDate(LocalDate.now().minusDays(355))
                    .expiryDate(LocalDate.now().plusDays(10))
                    .status(LicenseStatus.EXPIRING)
                    .build();
            licenseRepository.save(expiringLicense);
            log.info("Tugayotgan litsenziya yaratildi: TID-8842109");

            // 5. To'lovlar tarixi
            Payment oldPayment = Payment.builder()
                    .user(driverUser)
                    .amount(new BigDecimal("150000.00"))
                    .method("CLICK")
                    .status(PaymentStatus.SUCCESS)
                    .description("Litsenziya olish uchun dastlabki to'lov")
                    .build();
            paymentRepository.save(oldPayment);

            Payment pendingPayment = Payment.builder()
                    .user(driverUser)
                    .amount(new BigDecimal("150000.00"))
                    .method("PAYME")
                    .status(PaymentStatus.PENDING)
                    .description("Litsenziyani uzaytirish to'lovi (kutilmoqda)")
                    .build();
            paymentRepository.save(pendingPayment);
            log.info("To'lovlar tarixi yaratildi.");

            // 6. Bildirishnoma yaratish
            notificationService.createNotification(driverUser, "Litsenziya muddati tugamoqda",
                    "Sizning TID-8842109 raqamli litsenziyangiz muddati 10 kundan keyin tugaydi. Iltimos, harakatlanish cheklanishining oldini olish uchun uni uzaytiring.");
            
            log.info("Sinov ma'lumotlari muvaffaqiyatli yuklandi!");
        } else {
            log.info("Ma'lumotlar bazasida ma'lumotlar mavjud, seeder o'tkazib yuborildi.");
        }
    }
}
