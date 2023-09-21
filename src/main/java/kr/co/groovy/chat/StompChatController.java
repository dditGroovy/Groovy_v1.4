package kr.co.groovy.chat;

import kr.co.groovy.vo.ChatVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@Slf4j
@Controller
@RequiredArgsConstructor
public class StompChatController {

    private final SimpMessagingTemplate template;

    @MessageMapping("/chat/message")
    public void message(ChatVO message) {
        template.convertAndSend("/subscribe/chat/room/" + message.getChttRoomNo(), message);
    }

}
