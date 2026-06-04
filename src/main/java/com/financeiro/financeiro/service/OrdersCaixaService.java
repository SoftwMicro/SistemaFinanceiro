package com.financeiro.financeiro.service;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.repository.OrdersCaixaRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.financeiro.financeiro.model.StatusCaixa;

@Service
public class OrdersCaixaService {

    private final OrdersCaixaRepository repository;

    public OrdersCaixaService(OrdersCaixaRepository repository) {
        this.repository = repository;
    }

    public OrdersCaixa abrirCaixa(Long usuarioId, BigDecimal saldoInicial) {
        OrdersCaixa caixa = new OrdersCaixa();
        caixa.setUsuarioId(usuarioId);
        caixa.setDataAbertura(LocalDateTime.now());
        caixa.setSaldoInicial(saldoInicial);
        caixa.setStatus(StatusCaixa.ABERTO);
        return repository.save(caixa);
    }

    public OrdersCaixa fecharCaixa(Long caixaId, BigDecimal saldoFinal) {
        OrdersCaixa caixa = repository.findById(caixaId)
                .orElseThrow(() -> new RuntimeException("Caixa encontrado"));

        caixa.setDataFechamento(LocalDateTime.now());
        caixa.setSaldoFinal(saldoFinal);
        caixa.setStatus(StatusCaixa.FECHADO);
        return repository.save(caixa);
    }
}
