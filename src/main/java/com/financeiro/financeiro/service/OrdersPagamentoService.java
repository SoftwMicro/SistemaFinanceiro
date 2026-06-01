package com.financeiro.financeiro.service;

import com.financeiro.financeiro.dto.PaymentRequest;
import com.financeiro.financeiro.model.OrdersPagamento;
import com.financeiro.financeiro.repository.OrdersPagamentoRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

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

        OrdersPagamento pagamento = new OrdersPagamento();
        pagamento.setOrderId(orderId);
        pagamento.setFormaPagamento(request.getFormaPagamento());
        pagamento.setValorPago(request.getValorPago());
        pagamento.setDataPagamento(request.getDataPagamento() != null ? request.getDataPagamento() : LocalDateTime.now());
        pagamento.setStatusPagamento(request.getStatusPagamento());

        return repository.save(pagamento);
    }
}

