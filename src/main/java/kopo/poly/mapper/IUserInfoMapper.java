package kopo.poly.mapper;

import kopo.poly.dto.UserInfoDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

@Mapper
public interface IUserInfoMapper {

    int insertUserInfo(UserInfoDTO pDTO) throws Exception;

    UserInfoDTO getUserIdExists(UserInfoDTO pDTO) throws Exception;

    UserInfoDTO getEmailExists(UserInfoDTO pDTO) throws Exception;

 //   UserInfoDTO getEmailExists2(UserInfoDTO pDTO) throws Exception;

    UserInfoDTO getLogin(UserInfoDTO pDTO) throws Exception;

    UserInfoDTO getUserId(UserInfoDTO pDTO) throws Exception;

    int updatePassword(UserInfoDTO pDTO) throws Exception;

    UserInfoDTO getUserByEmail(@Param("email") String email);

    int insertToken(@Param("userId") String userId,
                    @Param("tokenHash") String tokenHash,
                    @Param("expiresAt") String expiresAt);

    Map<String, Object> getValidToken(@Param("tokenHash") String tokenHash);

    int consumeToken(@Param("tokenHash") String tokenHash);

}
