package kopo.poly.service.impl;

import kopo.poly.dto.ChatRoomActivityDTO;
import kopo.poly.mapper.IMyActivityMapper;
import kopo.poly.service.IMyActivityService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MyActivityService implements IMyActivityService {

    private final IMyActivityMapper myActivityMapper;

    @Override
    public List<ChatRoomActivityDTO> getMyChatRooms(String userId, int page, int size) {
        int offset = Math.max(0, (page - 1) * size);
        return myActivityMapper.selectMyChatRooms(userId, offset, size);
    }

    @Override
    public int countMyChatRooms(String userId) {
        return myActivityMapper.countMyChatRooms(userId);
    }
}
