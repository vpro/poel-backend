package nl.vpro.poel.repository;

import nl.vpro.poel.domain.Prediction;
import nl.vpro.poel.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PredictionRepository extends JpaRepository<Prediction, Long> {

    List<Prediction> findAllByUser(User user);
}