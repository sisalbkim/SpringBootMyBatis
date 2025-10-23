package kopo.poly.mapper;

import kopo.poly.dto.ChatRoomActivityDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface IMyActivityMapper {

    List<ChatRoomActivityDTO> selectMyChatRooms(
            @Param("userId") String userId,
            @Param("offset") int offset,
            @Param("limit") int limit
    );

    int countMyChatRooms(@Param("userId") String userId);
}
