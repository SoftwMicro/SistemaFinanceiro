package com.financeiro.financeiro.dto;

import com.financeiro.financeiro.model.OrdersReceipt;
import java.util.List;

public class ReceiptResponse {
    private OrdersReceipt receipt;
    private List<ReceiptRow> rows;

    public OrdersReceipt getReceipt() {
        return receipt;
    }

    public void setReceipt(OrdersReceipt receipt) {
        this.receipt = receipt;
    }

    public List<ReceiptRow> getRows() {
        return rows;
    }

    public void setRows(List<ReceiptRow> rows) {
        this.rows = rows;
    }
}

