package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OrdersReceiptRepository extends JpaRepository<OrdersReceipt, Long> {
    Optional<OrdersReceipt> findByOrderId(Long orderId);
}

