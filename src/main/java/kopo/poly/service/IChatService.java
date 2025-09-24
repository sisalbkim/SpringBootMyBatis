package kopo.poly.service;

import kopo.poly.dto.ChatDTO;
import kopo.poly.dto.ChatMessageDTO;

import java.util.List;

public interface IChatService {
    List<ChatDTO> getChatList() throws Exception;

    List<ChatDTO> getChatListByAddr(String addr1, String addr2) throws Exception;

    int createRoom(ChatDTO pDTO) throws Exception; // 방 생성 추가

    ChatDTO getRoomInfo(int chatRoomId) throws Exception;
    List<ChatMessageDTO> getMessages(int chatRoomId) throws Exception;
    int insertMessage(ChatMessageDTO pDTO) throws Exception;
    List<ChatMessageDTO> getMessageList(int chatRoomId) throws Exception;

    int getChatListCount() throws Exception;
    List<ChatDTO> getChatListPaged(int offset, int pageSize) throws Exception;

    int getChatListCountByAddr(String addr1, String addr2) throws Exception;
    List<ChatDTO> getChatListByAddrPaged(String addr1, String addr2, int offset, int pageSize) throws Exception;
}
