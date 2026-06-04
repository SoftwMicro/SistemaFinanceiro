package com.financeiro.financeiro.controller;

import com.financeiro.financeiro.dto.PaymentRequest;
import com.financeiro.financeiro.model.OrdersPagamento;
import com.financeiro.financeiro.service.OrdersPagamentoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/pagamentos")
public class OrdersPagamentoController {

    private final OrdersPagamentoService service;

    public OrdersPagamentoController(OrdersPagamentoService service) {
        this.service = service;
    }

    @PostMapping("/registrarPagamento")
    public ResponseEntity<?> registerPayment(@RequestBody PaymentRequest request) {
        try {
            OrdersPagamento saved = service.registerPayment(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(saved);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }
}

