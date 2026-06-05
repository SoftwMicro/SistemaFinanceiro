package com.financeiro.financeiro.dto;

import java.time.LocalDateTime;

public class ReceiptRequest {
    private Long orderId;
    private String numeroComprovante;
    private String tipo;
    private LocalDateTime dataEmissao;

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getNumeroComprovante() {
        return numeroComprovante;
    }

    public void setNumeroComprovante(String numeroComprovante) {
        this.numeroComprovante = numeroComprovante;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public LocalDateTime getDataEmissao() {
        return dataEmissao;
    }

    public void setDataEmissao(LocalDateTime dataEmissao) {
        this.dataEmissao = dataEmissao;
    }
}

