package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersReceipt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrdersReceiptRepository extends JpaRepository<OrdersReceipt, Long> {
}

