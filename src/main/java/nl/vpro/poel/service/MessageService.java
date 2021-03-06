package nl.vpro.poel.service;

import nl.vpro.poel.domain.Message;
import nl.vpro.poel.dto.MessageForm;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public interface MessageService {

    Optional<Message> findById(Long id);

    Optional<Message> findByKey(String key);

    Optional<String> getText(String key);

    List<Message> findAll();

    void setMessages(MessageForm messageForm);
}
