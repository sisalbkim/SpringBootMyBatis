package kopo.poly.service.impl;

import kopo.poly.dto.ChatDTO;
import kopo.poly.dto.ChatMessageDTO;
import kopo.poly.mapper.IChatMapper;
import kopo.poly.service.IChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;


import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class ChatService implements IChatService {

    private final IChatMapper chatMapper;

    /** 전체 채팅방 목록 */
    @Override
    public List<ChatDTO> getChatList() throws Exception {
        log.info("{}.getChatList Start!", this.getClass().getName());
        List<ChatDTO> rList = chatMapper.getChatList();

        if (rList == null || rList.isEmpty()) {
            log.warn("조회된 전체 채팅방이 없습니다!");
        } else {
            log.info("조회된 전체 채팅방 개수: {}", rList.size());
        }

        log.info("{}.getChatList End!", this.getClass().getName());
        return rList;
    }

    /** 주소별 채팅방 목록 */
    @Override
    public List<ChatDTO> getChatListByAddr(String addr1, String addr2) throws Exception {
        log.info("{}.getChatListByAddr Start!", this.getClass().getName());
        log.info("검색 조건 - addr1: {}, addr2: {}", addr1, addr2);

        List<ChatDTO> rList = chatMapper.getChatListByAddr(addr1, addr2);

        if (rList == null || rList.isEmpty()) {
            log.warn("조건에 맞는 채팅방이 없습니다! (addr1={}, addr2={})", addr1, addr2);
        } else {
            log.info("조회된 조건 채팅방 개수: {}", rList.size());
        }

        log.info("{}.getChatListByAddr End!", this.getClass().getName());
        return rList;
    }


    /** 채팅방 생성 */
    @Override
    public int createRoom(ChatDTO pDTO) throws Exception {
        log.info("{}.createRoom Start!", this.getClass().getName());
        int res = chatMapper.createRoom(pDTO);
        log.info("{}.createRoom End!", this.getClass().getName());
        return res;
    }


    /** 특정 채팅방 정보 조회 */
    @Override
    public ChatDTO getRoomInfo(int chatRoomId) throws Exception {
        log.info("{}.getRoomInfo Start!", this.getClass().getName());
        ChatDTO rDTO = chatMapper.getRoomInfo(chatRoomId);
        log.info("{}.getRoomInfo End!", this.getClass().getName());
        return rDTO;
    }

    /** 특정 채팅방 메시지 목록 조회 */
    @Override
    public List<ChatMessageDTO> getMessages(int chatRoomId) throws Exception {
        log.info("{}.getMessages Start!", this.getClass().getName());
        List<ChatMessageDTO> rList = chatMapper.getMessages(chatRoomId);
        log.info("{}.getMessages End!", this.getClass().getName());
        return rList;
    }

    /** 채팅 메시지 저장 */
    @Override
    public int insertMessage(ChatMessageDTO pDTO) throws Exception {
        log.info("{}.insertMessage Start!", this.getClass().getName());
        int res = chatMapper.insertMessage(pDTO);
        log.info("{}.insertMessage End!", this.getClass().getName());
        return res;
    }

    @Override
    public List<ChatMessageDTO> getMessageList(int chatRoomId) throws Exception {
        return chatMapper.getMessageList(chatRoomId);
    }

    @Override
    public int getChatListCount() throws Exception {
        return chatMapper.getChatListCount();
    }

    @Override
    public List<ChatDTO> getChatListPaged(int offset, int pageSize) throws Exception {
        return chatMapper.getChatListPaged(offset, pageSize);
    }

    @Override
    public int getChatListCountByAddr(String addr1, String addr2) throws Exception {
        return chatMapper.getChatListCountByAddr(addr1, addr2);
    }

    @Override
    public List<ChatDTO> getChatListByAddrPaged(String addr1, String addr2, int offset, int pageSize) throws Exception {
        return chatMapper.getChatListByAddrPaged(addr1, addr2, offset, pageSize);
    }
}
