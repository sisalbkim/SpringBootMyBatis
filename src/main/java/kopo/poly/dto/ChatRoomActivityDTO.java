package kopo.poly.dto;

import lombok.Data;

@Data
public class ChatRoomActivityDTO {
    private Long roomId;
    private String roomName;

    private String joinedAt;   // CHAT_MEMBER.JOINED_AT
    private Integer memberCnt; // COUNT(CHAT_MEMBER)

    private String lastMsg;    // 최근 메시지 내용
    private String lastMsgAt;  // 최근 메시지 시간
}
