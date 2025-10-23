package kopo.poly.service;

import kopo.poly.dto.UserInfoDTO;

public interface IMyPageService {
    UserInfoDTO getMyInfo(String userId);
    int updateProfile(UserInfoDTO p);   // 이름/주소/알림/프로필이미지 등 부분 수정
    int changePassword(UserInfoDTO p);  // 비밀번호 변경
}
