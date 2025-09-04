package kopo.poly.dto;

import lombok.Data;

@Data
public class ChatMessageDTO {
    private long msgId;
    private int chatRoomId;
    private String userId;
    private String message;
    private String sendTime;
}
