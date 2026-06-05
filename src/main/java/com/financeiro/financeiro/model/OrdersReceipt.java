package com.financeiro.financeiro.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders_receipt")
public class OrdersReceipt {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "order_id", nullable = false)
    private Long orderId;

    @Column(name = "numero_comprovante", nullable = false, length = 50)
    private String numeroComprovante;

    @Column(name = "tipo", nullable = false, length = 20)
    private String tipo;

    @Column(name = "data_emissao", nullable = false)
    private LocalDateTime dataEmissao;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

