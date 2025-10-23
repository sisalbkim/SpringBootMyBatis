package kopo.poly.service;

import kopo.poly.dto.ChatRoomActivityDTO;
import java.util.List;

public interface IMyActivityService {
    List<ChatRoomActivityDTO> getMyChatRooms(String userId, int page, int size);
    int countMyChatRooms(String userId);
}
