package kopo.poly.service.impl;

import kopo.poly.dto.MailDTO;
import kopo.poly.dto.UserInfoDTO;
import kopo.poly.mapper.IUserInfoMapper;
import kopo.poly.service.IMailService;
import kopo.poly.service.IUserInfoService;
import kopo.poly.util.CmmUtil;
import kopo.poly.util.DateUtil;
import kopo.poly.util.EncryptUtil;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

@Slf4j
@RequiredArgsConstructor
@Service
public class UserInfoService implements IUserInfoService {

    private final IUserInfoMapper userInfoMapper;

    private final IMailService mailService;

    private static final String baseUrl = "http://localhost:11000";

    @Override
    public UserInfoDTO getUserIdExists(UserInfoDTO pDTO) throws Exception{

        log.info("{}.getUserIdExists Start!", this.getClass().getName());

        UserInfoDTO rDTO = userInfoMapper.getUserIdExists(pDTO);

        log.info("{}.getUserIdExists End!", this.getClass().getName());

        return rDTO;
    }

    @Override
    public UserInfoDTO getEmailExists(UserInfoDTO pDTO) throws Exception{

        log.info("{}.emailAuth start!", this.getClass().getName());


        UserInfoDTO rDTO = Optional.ofNullable(userInfoMapper.getEmailExists(pDTO)).orElseGet(UserInfoDTO::new);
        log.info("pDTO : {}", pDTO);
        log.info("rDTO : {}", rDTO);
        //existsYn 값 확인
        String existsYn=CmmUtil.nvl(rDTO.getExistsYn());
        log.info("existsYn : {}", existsYn);

        if (CmmUtil.nvl(rDTO.getExistsYn()).equals("N")) {

            int authNumber = ThreadLocalRandom.current().nextInt(100000, 1000000);

            log.info("authNumber : {}", authNumber);

            MailDTO dto = new MailDTO();

            dto.setTitle("이메일 중복 확인 인증번호 발송 메일");
            dto.setContents("인증번호는 " + authNumber + " 입니다.");
            dto.setToMail(EncryptUtil.decAES128CBC(CmmUtil.nvl(pDTO.getEmail())));

            mailService.doSendMail(dto);

            dto = null;

            rDTO.setAuthNumber(authNumber);

        }


        log.info("{}.emailAuth End!", this.getClass().getName());

        return rDTO;
    }
    @Override
    public int insertUserInfo(UserInfoDTO pDTO) throws Exception {

        log.info("{}.insertUserInfo Start!", this.getClass().getName());

        int res;

        int success = userInfoMapper.insertUserInfo(pDTO);

        if (success > 0) {
            res = 1;

            MailDTO mDTO = new MailDTO();

            mDTO.setToMail(EncryptUtil.decAES128CBC(CmmUtil.nvl(pDTO.getEmail())));

            mDTO.setTitle("회원가입을 축하드립니다.");

            mDTO.setContents(CmmUtil.nvl(pDTO.getUserName()) + "님의 회원가입을 진심으로 축하드립니다.");

            mailService.doSendMail(mDTO);
        } else {
            res = 0;
        }

        log.info("{}.insertUserInfo End!", this.getClass().getName());

        return res;
    }

    @Override
    public UserInfoDTO getLogin(UserInfoDTO pDTO) throws Exception{
        log.info("{}.getLogin Start!", this.getClass().getName());

        UserInfoDTO rDTO = Optional.ofNullable(userInfoMapper.getLogin(pDTO)).orElseGet(UserInfoDTO::new);

        if (!CmmUtil.nvl(rDTO.getUserId()).isEmpty()) {

            MailDTO mDTO = new MailDTO();

            mDTO.setToMail(EncryptUtil.decAES128CBC(CmmUtil.nvl(pDTO.getEmail())));

            mDTO.setTitle("로그인 알림!");

            mDTO.setContents(DateUtil.getDateTime("yyyy.MM.dd hh:mm:ss") + "에"
            + CmmUtil.nvl(rDTO.getUserName()) + "님이 로그인하였습니다.");

            mailService.doSendMail(mDTO);
        }

        log.info("{}.getLogin End!", this.getClass().getName());

        return rDTO;
    }

    @Override
    public UserInfoDTO searchUserIdOrPasswordProc(UserInfoDTO pDTO) throws Exception{

        log.info("{}.searchUserIdOrPasswordProc Start!", this.getClass().getName());

        UserInfoDTO rDTO = userInfoMapper.getUserId(pDTO);

        log.info("{}.searchUserIdOrPasswordProc End!", this.getClass().getName());

        return rDTO;
    }

    @Override
    public int newPasswordProc(UserInfoDTO pDTO) throws Exception {

        log.info("{}.newPasswordProc Start!", this.getClass().getName());

        int success = userInfoMapper.updatePassword(pDTO);

        log.info("{}.newPasswordProc End!", this.getClass().getName());

        return success;

    }

    @Override
    public int sendResetLink(String plainEmail) throws Exception {
        log.info("sendResetLink start, email={}", plainEmail);

        String encEmail = EncryptUtil.encAES128CBC(plainEmail);

        UserInfoDTO u = Optional.ofNullable(userInfoMapper.getUserByEmail(encEmail)).orElse(null);
        if (u == null || CmmUtil.nvl(u.getUserId()).isEmpty()) {
            log.info("email not found, but respond ok");
            return 1;
        }

        String rawToken  = EncryptUtil.generateToken();
        String tokenHash = EncryptUtil.hashSHA256(rawToken);

        String expiresAt = java.time.LocalDateTime.now()
                .plusMinutes(30)
                .toString().replace('T',' ');

        userInfoMapper.insertToken(u.getUserId(), tokenHash, expiresAt);

        String userId = u.getUserId();

        String link = baseUrl + "/user/resetPassword?token=" + rawToken;

        MailDTO m = new MailDTO();
        m.setToMail(plainEmail);
        m.setTitle("[Atalk] 아이디 및 비밀번호 재설정 안내");
        String contents = "비밀번호를 분실시에는 재설정 해주셔야 됩니다.<br><br>" +
                "아이디: <strong>" + userId + "</strong><br>" +
                "비밀번호 재설정 주소: <a href=\"" + link + "\">" + link + "</a>";
        m.setContents(contents);

        mailService.doSendMail(m);

        log.info("sendResetLink end");
        return 1;
    }

    @Override
    public String verifyResetToken(String token) throws Exception {
        String hash = EncryptUtil.hashSHA256(token);
        Map<String,Object> row = userInfoMapper.getValidToken(hash);
        if (row == null) return null;
        return CmmUtil.nvl((String) row.get("USER_ID"));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int resetPassword(String token, String newPw) throws Exception {
        String userId = verifyResetToken(token);
        if (CmmUtil.nvl(userId).isEmpty()) return 0;

        UserInfoDTO p = new UserInfoDTO();
        p.setUserId(userId);
        p.setPassword(EncryptUtil.encHashSHA256(newPw));
        userInfoMapper.updatePassword(p);

        userInfoMapper.consumeToken(EncryptUtil.hashSHA256(token));
        return 1;
    }
}
