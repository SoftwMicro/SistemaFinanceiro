package com.financeiro.financeiro.repository;

import com.financeiro.financeiro.model.OrdersCaixa;
import com.financeiro.financeiro.model.StatusCaixa;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface OrdersCaixaRepository extends JpaRepository<OrdersCaixa, Long> {
    Optional<OrdersCaixa> findByUsuarioIdAndStatus(Long usuarioId, StatusCaixa status);

    @Query("SELECT c FROM OrdersCaixa c WHERE c.usuarioId = :usuarioId " +
           "AND ( (c.status = 'ABERTO' AND CAST(c.dataAbertura AS date) = :dataAtual) " +
           "      OR (c.status = 'FECHADO' AND CAST(c.dataFechamento AS date) = :dataAtual) )")
    List<OrdersCaixa> findCaixaAberturaFechamentoPorUsuarioEData(@Param("usuarioId") Long usuarioId,
                                                                 @Param("dataAtual") LocalDate dataAtual);
}

