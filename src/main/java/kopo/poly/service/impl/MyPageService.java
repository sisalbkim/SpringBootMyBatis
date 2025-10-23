package kopo.poly.service.impl;

import kopo.poly.dto.UserInfoDTO;
import kopo.poly.mapper.IUserInfoMapper;
import kopo.poly.service.IMyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MyPageService implements IMyPageService {

    private final IUserInfoMapper userInfoMapper;

    @Override
    public UserInfoDTO getMyInfo(String userId) {
        UserInfoDTO p = new UserInfoDTO();
        p.setUserId(userId);
        return userInfoMapper.findUserById(p);
    }

    @Override
    public int updateProfile(UserInfoDTO p) {
        return userInfoMapper.updateProfile(p);
    }

    @Override
    public int changePassword(UserInfoDTO p) {
        try {
            return userInfoMapper.updatePassword(p);
        } catch (Exception e) {
            // TODO: logger 사용 시 교체
            // log.error("updatePassword failed", e);
            throw new RuntimeException("비밀번호 변경 중 오류가 발생했습니다.", e);
        }
    }

}
