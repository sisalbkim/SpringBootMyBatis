package kopo.poly.dto;

import lombok.Data;

@Data
public class ChatRoomDTO {
    private Long roomId;
    private String roomName;
    private String joinedAt;
    private Integer memberCnt;
}
