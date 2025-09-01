package kopo.poly.dto;

import lombok.Data;

@Data
public class ChatDTO {
    private int roomId;
    private int locationId;
    private String roomName;
    private String regId;
    private String regDt; // 또는 LocalDateTime

}
