package com.financeiro.financeiro.controller;

import com.financeiro.financeiro.dto.ReceiptRequest;
import com.financeiro.financeiro.dto.ReceiptResponse;
import com.financeiro.financeiro.service.OrdersReceiptService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/comprovantes")
public class OrdersReceiptController {

    private final OrdersReceiptService service;

    public OrdersReceiptController(OrdersReceiptService service) {
        this.service = service;
    }

    @PostMapping("/emitir")
    public ResponseEntity<?> emitReceipt(@RequestBody ReceiptRequest request) {
        try {
            ReceiptResponse response = service.emitReceipt(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }
}

