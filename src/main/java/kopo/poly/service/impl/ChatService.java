package kopo.poly.service.impl;

import kopo.poly.dto.ChatDTO;
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

    @Override
    public List<ChatDTO> getChatList() throws Exception {
        log.info("{}.getChatList Start!", this.getClass().getName());
        List<ChatDTO> rList = chatMapper.getChatList();
        log.info("{}.getChatList End!", this.getClass().getName());
        return rList;
    }
}
