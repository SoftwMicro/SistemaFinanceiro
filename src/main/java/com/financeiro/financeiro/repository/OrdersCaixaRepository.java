package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.model.StatusCaixa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OrdersCaixaRepository extends JpaRepository<OrdersCaixa, Long> {
    Optional<OrdersCaixa> findByUsuarioIdAndStatus(Long usuarioId, StatusCaixa status);
}

