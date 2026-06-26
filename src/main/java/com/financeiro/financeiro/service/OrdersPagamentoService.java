package com.financeiro.financeiro.service;

import com.financeiro.financeiro.dto.PaymentRequest;
import com.financeiro.financeiro.model.OrdersPagamento;
import com.financeiro.financeiro.repository.OrdersPagamentoRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.math.BigDecimal;

@Service
public class OrdersPagamentoService {

    private final OrdersPagamentoRepository repository;
    private final JdbcTemplate jdbcTemplate;

    public OrdersPagamentoService(OrdersPagamentoRepository repository, JdbcTemplate jdbcTemplate) {
        this.repository = repository;
        this.jdbcTemplate = jdbcTemplate;
    }

    @Transactional
    public OrdersPagamento registerPayment(PaymentRequest request) {
        Long orderId = request.getOrderId();
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM orders_order WHERE id = ?",
                Integer.class,
                orderId
        );

        if (count == null || count == 0) {
            throw new IllegalArgumentException("Pedido não existe: " + orderId);
        }

        // Recupera o valor total do pedido
        BigDecimal orderTotal = jdbcTemplate.queryForObject(
                "SELECT valor_total FROM orders_order WHERE id = ?",
                BigDecimal.class,
                orderId
        );

        if (orderTotal == null) {
            throw new IllegalArgumentException("Não foi possível obter o valor total do pedido: " + orderId);
        }

        if (request.getValorPago() == null) {
            throw new IllegalArgumentException("valorPago é obrigatório");
        }

        // Soma pagamentos já registrados para este pedido
        BigDecimal existingSum = jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(valor_pago), 0) FROM orders_pagamento WHERE order_id = ?",
                BigDecimal.class,
                orderId
        );

        if (existingSum == null) {
            existingSum = BigDecimal.ZERO;
        }

        BigDecimal newAccumulated = existingSum.add(request.getValorPago());

        if (newAccumulated.compareTo(orderTotal) > 0) {
            throw new IllegalArgumentException("Valor do pagamento R$ (" + request.getValorPago() + ") faz com que a soma dos pagamentos (" + newAccumulated + ") ultrapasse o valor total do pedido R$ (" + orderTotal + ")");
        }

        OrdersPagamento pagamento = new OrdersPagamento();
        pagamento.setOrderId(orderId);
        pagamento.setFormaPagamento(request.getFormaPagamento());
        pagamento.setValorPago(request.getValorPago());
        pagamento.setDataPagamento(request.getDataPagamento() != null ? request.getDataPagamento() : LocalDateTime.now());
        pagamento.setStatusPagamento(request.getStatusPagamento());

        return repository.save(pagamento);
    }
}

