package kopo.poly.mapper;

import kopo.poly.dto.ChatDTO;
import kopo.poly.dto.ChatMessageDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IChatMapper {
    // 채팅방 목록
    List<ChatDTO> getChatList() throws Exception;

    // 주소로 채팅방 검색
    List<ChatDTO> getChatListByAddr(String addr) throws Exception;

    // 방 생성
    int createRoom(ChatDTO pDTO) throws Exception;


    // ✅ 채팅방 단일 조회 (입장 시)
    ChatDTO getRoomInfo(int chatRoomId) throws Exception;

    // ✅ 특정 방 메시지 전체 조회
    List<ChatMessageDTO> getMessages(int chatRoomId) throws Exception;

    // ✅ 메시지 저장
    int insertMessage(ChatMessageDTO pDTO) throws Exception;
}
