package com.financeiro.financeiro.controller;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.service.OrdersCaixaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/caixa")
@CrossOrigin(origins = "http://localhost:4200")
public class OrdersCaixaController {

    private final OrdersCaixaService service;

    public OrdersCaixaController(OrdersCaixaService service) {
        this.service = service;
    }

    @PostMapping("/abrir")
    public OrdersCaixa abrirCaixa(@RequestParam Long usuarioId,
                                  @RequestParam BigDecimal saldoInicial) {
        return service.abrirCaixa(usuarioId, saldoInicial);
    }

    @PostMapping("/fechar/{id}")
    public OrdersCaixa fecharCaixa(@PathVariable Long id,
                                   @RequestParam BigDecimal saldoFinal) {
        return service.fecharCaixa(id, saldoFinal);
    }

    @GetMapping("/obter-abertura-fechamento")
    public ResponseEntity<List<OrdersCaixa>> obterCaixaAberturaFechamento(@RequestParam Long usuarioId) {
        List<OrdersCaixa> caixas = service.obterCaixaAberturaFechamento(usuarioId);
        // Retorna 200 com a lista (pode estar vazia se não houver abertura/fechamento para o usuário na data atual)
        return ResponseEntity.ok(caixas);
    }
}

