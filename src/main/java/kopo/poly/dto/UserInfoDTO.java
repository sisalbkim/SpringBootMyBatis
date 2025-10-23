package kopo.poly.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class UserInfoDTO {

    private String userId;

    private String userName;

    private String password;

    private String email;

    private String addr1;

    private String addr2;

    private String regId;

    private String regDt;

    private String chgId;

    private String chgDt;

    private String existsYn;

    private int authNumber;

    private String profileImageUrl; // USER_INFO.PROFILE_IMAGE_URL

    private Boolean notifyEmail;    // USER_INFO.NOTIFY_EMAIL (TINYINT(1) ↔ Boolean 매핑)

    private String updatedAt;       // USER_INFO.UPDATED_AT (문자열로 받는다면 포맷은 DB 설정에 따름)
}
