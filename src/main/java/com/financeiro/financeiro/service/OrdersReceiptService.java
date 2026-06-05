package com.financeiro.financeiro.service;

import com.financeiro.financeiro.dto.ReceiptRequest;
import com.financeiro.financeiro.model.OrdersReceipt;
import com.financeiro.financeiro.repository.OrdersReceiptRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class OrdersReceiptService {

    private final OrdersReceiptRepository repository;
    private final JdbcTemplate jdbcTemplate;

    public OrdersReceiptService(OrdersReceiptRepository repository, JdbcTemplate jdbcTemplate) {
        this.repository = repository;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public OrdersReceipt emitReceipt(ReceiptRequest request) {
        Long orderId = request.getOrderId();
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM orders_order WHERE id = ?",
                Integer.class,
                orderId
        );

        if (count == null || count == 0) {
            throw new IllegalArgumentException("Pedido não existe: " + orderId);
        }

        OrdersReceipt receipt = new OrdersReceipt();
        receipt.setOrderId(orderId);

        String numero = request.getNumeroComprovante();
        if (numero == null || numero.trim().isEmpty()) {
            numero = "RCPT-" + orderId + "-" + System.currentTimeMillis();
        }
        receipt.setNumeroComprovante(numero);

        receipt.setTipo(request.getTipo());
        receipt.setDataEmissao(request.getDataEmissao() != null ? request.getDataEmissao() : LocalDateTime.now());

        return repository.save(receipt);
    }
}

