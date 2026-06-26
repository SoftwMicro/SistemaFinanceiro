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
    public com.financeiro.financeiro.dto.ReceiptResponse emitReceipt(ReceiptRequest request) {
        Long orderId = request.getOrderId();
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM orders_order WHERE id = ?",
                Integer.class,
                orderId
        );

        if (count == null || count == 0) {
            throw new IllegalArgumentException("Pedido não existe: " + orderId);
        }

        // Verifica se existe pagamento para o pedido
        Integer paymentCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(1) FROM orders_pagamento WHERE order_id = ?",
                Integer.class,
                orderId
        );

        if (paymentCount == null || paymentCount == 0) {
            throw new IllegalArgumentException("Não existe pagamento para o pedido informado: " + orderId);
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

        OrdersReceipt saved = repository.save(receipt);

        // Monta os dados do comprovante conforme a query solicitada
        String sql = "SELECT " +
                "oi.pedido_id, " +
                "oi.quantidade, " +
                "oi.preco_unitario, " +
                "oi.subtotal, " +
                "p.sku, " +
                "p.nome AS nome_produto, " +
                "pag.forma_pagamento, " +
                "pag.valor_pago, " +
                "DATE_FORMAT(pag.data_pagamento, '%d/%m/%Y %H:%i') AS data_pagamento, " +
                "pag.status_pagamento, " +
                "SUM(oi.subtotal) OVER(PARTITION BY oi.pedido_id) AS total_geral " +
                "FROM orders_orderitem oi " +
                "INNER JOIN orders_produto p ON oi.produto_id = p.id " +
                "LEFT JOIN orders_pagamento pag ON oi.pedido_id = pag.order_id " +
                "WHERE oi.pedido_id = ?";

        java.util.List<com.financeiro.financeiro.dto.ReceiptRow> rows = jdbcTemplate.query(
                sql,
                new Object[]{orderId},
                (rs, rowNum) -> {
                    com.financeiro.financeiro.dto.ReceiptRow r = new com.financeiro.financeiro.dto.ReceiptRow();
                    r.setPedidoId(rs.getLong("pedido_id"));
                    r.setQuantidade(rs.getInt("quantidade"));
                    r.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
                    r.setSubtotal(rs.getBigDecimal("subtotal"));
                    r.setSku(rs.getString("sku"));
                    r.setNomeProduto(rs.getString("nome_produto"));
                    r.setFormaPagamento(rs.getString("forma_pagamento"));
                    r.setValorPago(rs.getBigDecimal("valor_pago"));
                    r.setDataPagamento(rs.getString("data_pagamento"));
                    r.setStatusPagamento(rs.getString("status_pagamento"));
                    r.setTotalGeral(rs.getBigDecimal("total_geral"));
                    return r;
                }
        );

        com.financeiro.financeiro.dto.ReceiptResponse response = new com.financeiro.financeiro.dto.ReceiptResponse();
        response.setReceipt(saved);
        response.setRows(rows);

        return response;
    }
}

