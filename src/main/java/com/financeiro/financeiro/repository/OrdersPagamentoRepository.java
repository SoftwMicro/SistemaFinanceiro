package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersPagamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrdersPagamentoRepository extends JpaRepository<OrdersPagamento, Long> {
}

