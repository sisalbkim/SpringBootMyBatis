package kopo.poly.dto;

import lombok.Data;

@Data
public class ChatDTO {
    private Integer roomId;      // AUTO_INCREMENT 기본키
    private String roomName; // 채팅방 이름
    private String regId;    // 등록자 ID
    private String regDt;    // 등록일자
    private String addr1;    // 주소1
    private String addr2;    // 주소2
    private String userId;   // 방 만든 사람
    private int userCount;   // 참여자 수 (추가!)
}
