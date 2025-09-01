package kopo.poly.service;

import kopo.poly.dto.ChatDTO;
import java.util.List;

public interface IChatService {
    List<ChatDTO> getChatList() throws Exception;
}
