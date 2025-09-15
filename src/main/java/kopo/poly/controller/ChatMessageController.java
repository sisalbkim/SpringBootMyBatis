package kopo.poly.controller;

import kopo.poly.dto.ChatMessageDTO;
import kopo.poly.service.IChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Slf4j
@RequiredArgsConstructor
@Controller
public class ChatMessageController {

    private final IChatService chatService;

    @MessageMapping("/chat.sendMessage")   // 클라이언트 → 서버
    @SendTo("/topic/public")               // 서버 → 구독자
    public ChatMessageDTO sendMessage(@Payload ChatMessageDTO chatMessage) throws Exception {
        log.info("메시지 수신: {}", chatMessage);

        // ✅ DB 저장
        chatService.insertMessage(chatMessage);

        // 그대로 브로드캐스트
        return chatMessage;
    }
}
