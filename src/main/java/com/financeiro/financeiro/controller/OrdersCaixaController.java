package com.financeiro.financeiro.controller;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.service.OrdersCaixaService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.math.BigDecimal;

@RestController
@RequestMapping("/caixa")
@CrossOrigin(origins = "http://localhost:4200")
public class OrdersCaixaController {

    private final OrdersCaixaService service;

    public OrdersCaixaController(OrdersCaixaService service) {
        this.service = service;
    }

    @PostMapping("/open")
    public OrdersCaixa abrirCaixa(@RequestParam Long usuarioId,
                                  @RequestParam BigDecimal saldoInicial) {
        return service.abrirCaixa(usuarioId, saldoInicial);
    }

    @PostMapping("/fechar/{id}")
    public OrdersCaixa fecharCaixa(@PathVariable Long id,
                                   @RequestParam BigDecimal saldoFinal) {
        return service.fecharCaixa(id, saldoFinal);
    }
}

