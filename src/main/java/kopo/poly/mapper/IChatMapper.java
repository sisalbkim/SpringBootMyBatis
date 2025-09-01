package kopo.poly.mapper;

import kopo.poly.dto.ChatDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IChatMapper {
    List<ChatDTO> getChatList() throws Exception;
}
