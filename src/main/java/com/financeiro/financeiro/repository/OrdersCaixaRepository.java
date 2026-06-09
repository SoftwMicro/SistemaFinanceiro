package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.model.StatusCaixa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface OrdersCaixaRepository extends JpaRepository<OrdersCaixa, Long> {
    Optional<OrdersCaixa> findByUsuarioIdAndStatus(Long usuarioId, StatusCaixa status);

    @Query("SELECT c FROM OrdersCaixa c WHERE c.usuarioId = :usuarioId " +
           "AND c.status = 'ABERTO' " +
           "AND CAST(c.dataAbertura AS date) = :dataAtual")
    Optional<OrdersCaixa> findCaixaAbertoPorUsuarioEData(@Param("usuarioId") Long usuarioId,
                                                         @Param("dataAtual") LocalDate dataAtual);
}

