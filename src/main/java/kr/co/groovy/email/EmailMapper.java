package kr.co.groovy.email;

import kr.co.groovy.vo.EmailVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface EmailMapper {
    int inputReceivedEmailsFrom(EmailVO emailVO);

    int inputReceivedEmailsTo(EmailVO emailVO);

    int inputReceivedEmailsCc(EmailVO emailVO);

    int inputReceivedStatus(EmailVO emailVO);

    List<EmailVO> getAllReceivedMailsToMe(Map<String, String> map);

    List<EmailVO> getAllReferencedMailsToMe(Map<String, String> map);

    List<EmailVO> getAllSentMailsToMe(Map<String, String> map);

    List<EmailVO> getAllSentMailsByMe(Map<String, String> map);

    int getEmployeeByEmailAddr(String emailAddr);

    int existsMessageNumber(Map<String, Object> map);

    int modifyEmailRedngAt(Map<String, String> map);

    int deleteMails(String emailEtprCode);

    int getUnreadMailCount(String emplId);

    int getAllMailCount(String emailAddr);

    int getEmailSeq();

    void uploadEmailFile(Map<String, Object> map);

    String getEmplNmByEmplEmail(String emailAddr);

    int getMaxEmailSn();

    EmailVO getNowEmail(Map<String, String> map);

    List<EmailVO> getToPerEmail(Map<String, String> map);

    List<EmailVO> getCcPerEmail(Map<String, String> map);
}
