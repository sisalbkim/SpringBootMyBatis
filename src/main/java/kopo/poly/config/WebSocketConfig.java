package kopo.poly.config;

import kopo.poly.chat.ChatHandler;
import kopo.poly.util.CmmUtil;
import kopo.poly.util.EncryptUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.*;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import java.util.Map;

/**
 * ✅ 통합 WebSocket 설정
 * - 1) STOMP (MessageBroker 기반)
 * - 2) Raw WebSocket (직접 핸들러 등록)
 */
@Slf4j
@RequiredArgsConstructor
@Configuration
@EnableWebSocket
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketConfigurer, WebSocketMessageBrokerConfigurer {

    private final ChatHandler chatHandler;

    /**
     * ✅ STOMP 설정 (네 코드)
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // 구독 prefix
        config.enableSimpleBroker("/topic");
        // 발행 prefix
        config.setApplicationDestinationPrefixes("/app");
    }

    /**
     * ✅ STOMP Endpoint 설정
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws-chat")
                .setAllowedOriginPatterns("*")
                .withSockJS(); // SockJS 지원
    }

    /**
     * ✅ Raw WebSocket 핸들러 설정 (교수님 코드)
     */
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        log.info("Raw WebSocket Handler 등록");

        registry.addHandler(chatHandler, "/ws/*/*/*")
                .setAllowedOrigins("*")
                .addInterceptors(new HttpSessionHandshakeInterceptor() {
                    @Override
                    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                                   WebSocketHandler wsHandler, Map<String, Object> attributes)
                            throws Exception {

                        String path = CmmUtil.nvl(request.getURI().getPath());
                        log.info("path : {}", path);

                        String[] urlInfo = path.split("/");

                        if (urlInfo.length >= 5) {
                            String roomName = CmmUtil.nvl(urlInfo[2]); // 채팅방 이름
                            String userName = CmmUtil.nvl(urlInfo[3]); // 사용자 이름
                            String langCode = CmmUtil.nvl(urlInfo[4]); // 언어 코드

                            String roomNameHash = EncryptUtil.encHashSHA256(roomName);

                            log.info("roomName : {}, userName : {}, langCode : {}",
                                    roomName, userName, langCode);

                            attributes.put("roomName", roomName);
                            attributes.put("userName", userName);
                            attributes.put("roomNameHash", roomNameHash);
                            attributes.put("langCode", langCode);
                        } else {
                            log.warn("URI Path가 예상 형식과 다릅니다: {}", path);
                        }

                        return super.beforeHandshake(request, response, wsHandler, attributes);
                    }
                });
    }
}
