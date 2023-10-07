package kr.co.groovy.email;

import kr.co.groovy.employee.EmployeeMapper;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.EmailVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.PageVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final EmailMapper emailMapper;
    private final EmployeeMapper employeeMapper;
    private final String uploadPath;
    private String password;

    public void inputReceivedEmailsFrom(EmailVO emailVO) {
        emailMapper.inputReceivedEmailsFrom(emailVO);
    }

    public void inputReceivedEmailsTo(EmailVO emailVO) {
        emailMapper.inputReceivedEmailsTo(emailVO);
    }

    public void inputReceivedEmailsCc(EmailVO emailVO) {
        emailMapper.inputReceivedEmailsCc(emailVO);
    }

    public void inputReceivedStatus(EmailVO emailVO) {
        emailMapper.inputReceivedStatus(emailVO);
    }

    public int existsMessageNumber(Map<String, Object> map) {
        return emailMapper.existsMessageNumber(map);
    }

    public List<EmailVO> getAllReceivedMailsToMe(Map<String, Object> map) {
        return emailMapper.getAllReceivedMailsToMe(map);
    }

    public List<EmailVO> getAllReferencedMailsToMe(Map<String, Object> map) {
        return emailMapper.getAllReferencedMailsToMe(map);
    }

    public List<EmailVO> getAllSentMailsToMe(Map<String, Object> map) {
        return emailMapper.getAllSentMailsToMe(map);
    }

    public List<EmailVO> getAllSentMailsByMe(Map<String, Object> map) {
        return emailMapper.getAllSentMailsByMe(map);
    }

    public int getEmployeeByEmailAddr(String emailAddr) {
        return emailMapper.getEmployeeByEmailAddr(emailAddr);
    }

    public void modifyEmailRedngAt(Map<String, String> map) {
        emailMapper.modifyEmailRedngAt(map);
    }

    public int deleteMails(String emailEtprCode) {
        return emailMapper.deleteMails(emailEtprCode);
    }

    public int getUnreadMailCount(String emplId) {
        return emailMapper.getUnreadMailCount(emplId);
    }

    public long getAllMailCount(String emplId) {
        return emailMapper.getAllMailCount(emplId);
    }

    public EmailVO getEmail(String emailEtprCode, String emailAddr) {
        Map<String, String> map = new HashMap<>();
        map.put("emailEtprCode", emailEtprCode);
        map.put("emailFromAddr", emailAddr);
        EmailVO nowEmail = emailMapper.getNowEmail(map);
        String emailFromAddr = nowEmail.getEmailFromAddr();
        if (emailFromAddr.contains("<")) {
            nowEmail.setEmailFromAddr(emailFromAddr.substring(emailFromAddr.indexOf('<') + 1, emailFromAddr.indexOf('>')));
        }
        return nowEmail;
    }

    public List<EmailVO> getToPerEmail(String emailEtprCode, String emailAddr) {
        Map<String, String> map = new HashMap<>();
        map.put("emailEtprCode", emailEtprCode);
        map.put("emailAddr", emailAddr);
        return emailMapper.getToPerEmail(map);
    }

    public List<EmailVO> getCcPerEmail(String emailEtprCode, String emailAddr) {
        Map<String, String> map = new HashMap<>();
        map.put("emailEtprCode", emailEtprCode);
        map.put("emailAddr", emailAddr);
        return emailMapper.getCcPerEmail(map);
    }

    public List<EmailVO> getAllReceivedMailList(EmployeeVO employeeVO, PageVO pageVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("emailAddr", employeeVO.getEmplEmail());
        map.put("at", "N");
        List<EmailVO> allReceivedMailsToMe = emailMapper.getAllReceivedMailsToMe(map);
        List<EmailVO> allReferencedMailsToMe = emailMapper.getAllReferencedMailsToMe(map);

        List<EmailVO> allReceivedMails = new ArrayList<>();
        allReceivedMails.addAll(allReceivedMailsToMe);
        allReceivedMails.addAll(allReferencedMailsToMe);
        allReceivedMails.sort(new Comparator<EmailVO>() {
            @Override
            public int compare(EmailVO vo1, EmailVO vo2) {
                Integer emailSn1 = vo1.getEmailSn();
                Integer emailSn2 = vo2.getEmailSn();
                return emailSn1.compareTo(emailSn2) * -1;
            }
        });

        pageVO.setRow();
        pageVO.setNum((long) allReceivedMails.size());

        int startIdx = Math.toIntExact(pageVO.getStartRow());
        int endIdx = Math.min(Math.toIntExact(pageVO.getLastRow()), allReceivedMails.size());

        if (startIdx <= endIdx) {
            return allReceivedMails.subList(startIdx, endIdx);
        } else {
            return new ArrayList<>();
        }
    }

    public List<EmailVO> getAllSentMailsByMe(EmployeeVO employeeVO, PageVO pageVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("emailAddr", employeeVO.getEmplEmail());
        map.put("at", "N");

        List<EmailVO> list = emailMapper.getAllSentMailsByMe(map);
        pageVO.setRow();
        pageVO.setNum((long) list.size());

        int startIdx = Math.toIntExact(pageVO.getStartRow());
        int endIdx = Math.min(Math.toIntExact(pageVO.getLastRow()), list.size());

        if (startIdx <= endIdx) {
            return list.subList(startIdx, endIdx);
        } else {
            return new ArrayList<>();
        }
    }

    public List<EmailVO> getSentMailsToMe(EmployeeVO employeeVO, PageVO pageVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("emailAddr", employeeVO.getEmplEmail());
        map.put("at", "N");
        List<EmailVO> list = emailMapper.getAllSentMailsToMe(map);
        pageVO.setRow();
        pageVO.setNum((long) list.size());

        int startIdx = Math.toIntExact(pageVO.getStartRow());
        int endIdx = Math.min(Math.toIntExact(pageVO.getLastRow()), list.size());

        if (startIdx <= endIdx) {
            return list.subList(startIdx, endIdx);
        } else {
            return new ArrayList<>();
        }
    }

    public Map<String, String> getEmailAtMap(String code, String emailEtprCode, String at) {
        Map<String, String> map = new HashMap<>();
        switch (code) {
            case "redng":
                map.put("emailAtKind", "EMAIL_REDNG_AT");
                break;
            case "imprtnc":
                map.put("emailAtKind", "EMAIL_IMPRTNC_AT");
                break;
            case "delete":
                map.put("emailAtKind", "EMAIL_DELETE_AT");
                break;
        }

        if (at.equals("N")) {
            map.put("at", "Y");
        } else {
            map.put("at", "N");
        }
        map.put("emailEtprCode", emailEtprCode);
        emailMapper.modifyEmailRedngAt(map);
        return map;
    }

    public JavaMailSenderImpl googleMailSender(String email, String password) {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.gmail.com");
        mailSender.setPort(587);
        mailSender.setUsername(email);
        mailSender.setPassword(password);

        Properties javaMailProperties = new Properties();
        javaMailProperties.put("mail.smtp.starttls.enable", "true");
        javaMailProperties.put("mail.smtp.auth", "true");
        javaMailProperties.put("mail.transport.protocol", "smtp");
        javaMailProperties.put("mail.debug", "true");
        javaMailProperties.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        javaMailProperties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        mailSender.setJavaMailProperties(javaMailProperties);
        return mailSender;
    }

    public JavaMailSenderImpl naverMailSender(String email, String password) {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.naver.com");
        return getMailSender(email, password, mailSender);
    }

    public JavaMailSenderImpl daumMailSender(String email, String password) {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.daum.net");
        return getMailSender(email, password, mailSender);
    }

    public JavaMailSenderImpl getMailSender(String email, String password, JavaMailSenderImpl mailSender) {
        mailSender.setPort(465);
        mailSender.setUsername(email);
        mailSender.setPassword(password);

        Properties javaMailProperties = new Properties();
        javaMailProperties.put("mail.smtp.auth", "true");
        javaMailProperties.put("mail.smtp.starttls.enable", "true");
        javaMailProperties.put("mail.smtps.checkserveridentity", "true");
        javaMailProperties.put("mail.smtps.ssl.trust", "*");
        javaMailProperties.put("mail.debug", "true");
        javaMailProperties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        mailSender.setJavaMailProperties(javaMailProperties);

        return mailSender;
    }

    public List<EmailVO> inputReceivedEmails(Principal principal, EmailVO emailVO, String password) throws Exception {
        EmployeeVO employeeVO = employeeMapper.loadEmp(principal.getName());
        this.password = password;
        URLName url = getUrlName(employeeVO, password);

        Session session = null;
        Properties properties = null;
        try {
            properties = System.getProperties();
        } catch (SecurityException e) {
            properties = new Properties();
        }
        session = Session.getInstance(properties, null);
        Store store = session.getStore(url);
        store.connect();
        Folder folder = store.getFolder("inbox");
        folder.open(Folder.READ_ONLY);

        Map<String, Object> map = new HashMap<>();
        Message[] messages = folder.getMessages();
        for (Message mail : messages) {
            emailVO.setEmailSn(mail.getMessageNumber());
            map.put("emailSn", emailVO.getEmailSn());
            map.put("nowEmailAddr", employeeVO.getEmplEmail());

            if (emailMapper.existsMessageNumber(map) == 0) { // 메시지 순번 검색 개수가 0이면
                // 발신부
                String subject = mail.getSubject();
                if (subject.contains("UTF-8")) {
                    try {
                        String encodedText = subject.split("\\?")[3];
                        byte[] decodedBytes = Base64.getDecoder().decode(encodedText.getBytes(StandardCharsets.UTF_8));
                        String decodedText = new String(decodedBytes, StandardCharsets.UTF_8);
                        subject = "[" + decodedText + "]" + subject.substring(subject.indexOf("]") + 1);
                    } catch (IllegalArgumentException e) {
                        e.getMessage();
                    }
                }

                String from = String.valueOf(mail.getFrom()[0]);
                if (from.startsWith("=?")) {
                    try {
                        InternetAddress decodedAddress = new InternetAddress(from, true);
                        String decodedEmail = decodedAddress.getAddress();
                        String decodedPersonal = null;

                        if (emailMapper.getEmployeeByEmailAddr(decodedEmail) == 0) {
                            decodedPersonal = decodedAddress.getPersonal();
                        } else {
                            decodedPersonal = decodedAddress.getPersonal();
                            String dept = Department.valueOf(employeeVO.getCommonCodeDept()).label();
                            decodedPersonal = decodedPersonal + " (" + dept + "팀)";
                        }
                        decodedPersonal = decodedPersonal.replaceAll("[^ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]", "");
                        from = decodedPersonal + "<" + decodedEmail + ">";
                    } catch (AddressException e) {
                        e.getMessage();
                    }
                }

                String content = "";
                if (mail.getSubject() != null) {
                    if (mail.isMimeType("multipart/*")) {
                        MimeMultipart mimeMultipart = (MimeMultipart) mail.getContent();
                        content = getTextFromMimeMultipart(mimeMultipart);
                    } else if (mail.isMimeType("text/*")) {
                        content = mail.getContent().toString();
                    }
                }

                emailVO.setEmailFromAddr(from);
                emailVO.setEmailFromSj(subject);
                emailVO.setEmailFromCn(content);
                emailVO.setEmailFromCnType(mail.getContentType());
                emailVO.setEmailFromSendDate(mail.getSentDate());
                emailVO.setEmailFromTmprStreAt("N");
                emailMapper.inputReceivedEmailsFrom(emailVO);

                emailVO.setEmailReceivedEmplId(employeeVO.getEmplId());
                emailVO.setEmailRedngAt("N");
                emailVO.setEmailDeleteAt("N");
                emailVO.setEmailImprtncAt("N");
                emailVO.setEmailRealDeleteAt("N");
                emailMapper.inputReceivedStatus(emailVO);

                // 수신부
                try {
                    Address[] toArray = mail.getRecipients(Message.RecipientType.TO);
                    for (Address to : toArray) {
                        emailVO.setEmailToAddr(String.valueOf(to));
                        emailVO.setEmailToReceivedDate(emailVO.getEmailFromSendDate());
                        emailMapper.inputReceivedEmailsTo(emailVO);
                    }
                } catch (NullPointerException e) {
                    e.getMessage();
                }

                // 참조부
                try {
                    Address[] ccArray = mail.getRecipients(Message.RecipientType.CC);
                    for (Address cc : ccArray) {
                        emailVO.setEmailCcAddr(String.valueOf(cc));
                        emailVO.setEmailCcReceivedDate(emailVO.getEmailFromSendDate());
                        emailMapper.inputReceivedEmailsCc(emailVO);
                    }
                } catch (NullPointerException e) {
                    e.getMessage();
                }
            }
        }
        return setAllEmailList(employeeVO.getEmplEmail(), "N");
    }

    private URLName getUrlName(EmployeeVO employeeVO, String password) {
        String host = null;
        int port = 995;
        String emailAddr = employeeVO.getEmplEmail();
        if (employeeVO.getEmplEmail().contains("noreply")) {
            password = "zwhfanbijftbggwx@1";
            host = "pop.daum.net";
        } else if (employeeVO.getEmplEmail().contains("daum.net")) {
            password = this.password;
            host = "pop.daum.net";
        } else if (employeeVO.getEmplEmail().contains("naver.com")) {
            password = this.password;
            host = "pop.naver.com";
        }
        return new URLName("pop3s", host, port, "INBOX", emailAddr, password);
    }

    public List<EmailVO> setAllEmailList(String emailAddr, String at) {
        Map<String, Object> map = new HashMap<>();
        map.put("emailAddr", emailAddr);
        map.put("at", at);
        List<EmailVO> receivedMails = emailMapper.getAllReceivedMailsToMe(map);
        for (EmailVO mail : receivedMails) {
            mail.setEmailBoxName("받은메일함");
            getEmplNmByEmplEmail(mail);
        }
        List<EmailVO> referencedMails = emailMapper.getAllReferencedMailsToMe(map);
        for (EmailVO mail : referencedMails) {
            mail.setEmailBoxName("받은메일함");
            getEmplNmByEmplEmail(mail);
        }
        List<EmailVO> allSentMailsToMe = emailMapper.getAllSentMailsToMe(map);
        for (EmailVO mail : allSentMailsToMe) {
            mail.setEmailBoxName("내게쓴메일함");
            getEmplNmByEmplEmail(mail);
        }
        List<EmailVO> allSentMailsByMe = emailMapper.getAllSentMailsByMe(map);
        for (EmailVO mail : allSentMailsByMe) {
            mail.setEmailBoxName("보낸메일함");
            getEmplNmByEmplEmail(mail);
        }
        List<EmailVO> allMails = new ArrayList<>();
        allMails.addAll(receivedMails);
        allMails.addAll(referencedMails);
        allMails.addAll(allSentMailsToMe);
        allMails.addAll(allSentMailsByMe);

        allMails.sort(new Comparator<EmailVO>() {
            @Override
            public int compare(EmailVO vo1, EmailVO vo2) {
                Date seq1 = vo1.getEmailFromSendDate();
                Date seq2 = vo2.getEmailFromSendDate();
                return seq1.compareTo(seq2) * -1;
            }
        });

        return allMails;
    }

    public String getEmplNmByEmplEmail(EmailVO mail) {
        String emplNmByEmplEmail = emailMapper.getEmplNmByEmplEmail(mail.getEmailFromAddr());
        if (emplNmByEmplEmail != null) {
            mail.setEmailFromAddr(emplNmByEmplEmail);
        }
        return mail.getEmailFromAddr();
    }

    private String getTextFromMimeMultipart(MimeMultipart mimeMultipart) throws MessagingException, IOException {
        String content = "";
        int count = mimeMultipart.getCount();
        for (int i = 0; i < count; i++) {
            BodyPart bodyPart = mimeMultipart.getBodyPart(i);
            if (bodyPart.isMimeType("text/plain")) {
                content = content + "\n" + bodyPart.getContent();
                break; // without break same text appears twice in my tests
            } else if (bodyPart.isMimeType("text/html")) {
                String html = (String) bodyPart.getContent();
                content = content + "\n" + Jsoup.parse(html).text();
            } else if (bodyPart.getContent() instanceof MimeMultipart) {
                content = content + getTextFromMimeMultipart((MimeMultipart) bodyPart.getContent());
            }
        }
        return content;
    }

    public String sentMail(EmailVO emailVO, MultipartFile[] emailFiles, EmployeeVO employeeVO) {
        String emplEmail = employeeVO.getEmplEmail();
        String password = this.password;
        JavaMailSenderImpl mailSender = null;
        if (emplEmail.contains("naver.com")) {
            mailSender = naverMailSender(emplEmail, password);
        } else if (emplEmail.contains("noreply")) {
            mailSender = daumMailSender(emplEmail, "zwhfanbijftbggwx@1");
        } else if (emplEmail.contains("daum.net")) {
            mailSender = daumMailSender(emplEmail, password);
        }

        List<String> toList = new ArrayList<>();
        String[] toArr;
        if (emailVO.getEmailToAddr() == null || emailVO.getEmailToAddr() == "") {
            if (emailVO.getEmplIdToList() != null || emailVO.getEmailToAddrList() != null) {
                List<String> emplIdToList = emailVO.getEmplIdToList();
                for (String emplId : emplIdToList) {
                    EmployeeVO emailToEmpl = employeeMapper.loadEmp(emplId);
                    emplIdToList.clear();
                    emplIdToList.add(emailToEmpl.getEmplEmail());
                }
                toList.addAll(emplIdToList);
                toList.addAll(emailVO.getEmailToAddrList());
            }
            toArr = toList.toArray(new String[0]);
        } else {
            toArr = null;
        }

        List<String> ccList = new ArrayList<>();
        if (emailVO.getEmplIdCcList() != null || emailVO.getEmailCcAddrList() != null) {
            List<String> emplIdCcList = emailVO.getEmplIdCcList();
            for (String emplId : emplIdCcList) {
                EmployeeVO emailCcEmpl = employeeMapper.loadEmp(emplId);
                emplIdCcList.clear();
                emplIdCcList.add(emailCcEmpl.getEmplEmail());
            }
            ccList.addAll(emplIdCcList);
            ccList.addAll(emailVO.getEmailCcAddrList());
        }
        String[] ccArr = ccList.toArray(new String[0]);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            if (toArr == null) {
                helper.setTo(emailVO.getEmailToAddr());
            } else if (toArr != null) {
                helper.setTo(toArr);
            }
            helper.setCc(ccArr);
            helper.setFrom(emplEmail);
            String emailFromSj = emailVO.getEmailFromSj();
            if (emailFromSj == null || emailFromSj.isEmpty()) {
                emailFromSj = "(제목 없음)";
            }
            helper.setSubject(emailFromSj);

            String emailFromCn = emailVO.getEmailFromCn();
            if (emailFromCn.startsWith(",")) {
                helper.setText(emailFromCn.substring(1), true);
            } else {
                helper.setText(emailFromCn);
            }

            helper.setSentDate(new Date());

            for (MultipartFile emailFile : emailFiles) {
                if (!emailFile.getOriginalFilename().isEmpty()) {
                    String fileName = StringUtils.cleanPath(emailFile.getOriginalFilename());
                    helper.addAttachment(MimeUtility.encodeText(fileName, "UTF-8", "B"), new ByteArrayResource(IOUtils.toByteArray(emailFile.getInputStream())));
                }
            }

            EmailVO sendMail = new EmailVO();
            sendMail.setEmailSn(emailMapper.getMaxEmailSn() + 1);
            sendMail.setEmailFromAddr(emplEmail);
            sendMail.setEmailFromSendDate(helper.getMimeMessage().getSentDate());
            sendMail.setEmailFromSj(emailVO.getEmailFromSj());
            sendMail.setEmailFromCn(emailFromCn);
            sendMail.setEmailFromTmprStreAt("N");
            sendMail.setEmailFromCnType(message.getContentType());
            sendMail.setEmailSn(emailVO.getEmailSn());
            emailMapper.inputReceivedEmailsFrom(sendMail);



            if (emailVO.getEmailToAddr() == null) {
                List<String> emailToAddrList = Arrays.asList(toArr);
                try {
                    for (String to : emailToAddrList) {
                        sendMail.setEmailToAddr(to);
                        sendMail.setEmailToReceivedDate(new Date());
                    }
                } catch (NullPointerException e) {
                    e.getMessage();
                }
            } else {
                sendMail.setEmailToAddr(emailVO.getEmailToAddr());
                sendMail.setEmailToReceivedDate(new Date());
            }
            emailMapper.inputReceivedEmailsTo(sendMail);

            List<String> emailCcAddrList = emailVO.getEmailCcAddrList();
            if ((emailCcAddrList != null) && !emailCcAddrList.isEmpty()) {
                try {
                    for (String cc : emailCcAddrList) {
                        sendMail.setEmailCcAddr(cc);
                        sendMail.setEmailCcReceivedDate(new Date());
                    }
                    emailMapper.inputReceivedEmailsCc(sendMail);
                } catch (NullPointerException e) {
                    e.getMessage();
                }
            }

            sendMail.setEmailImprtncAt("N");
            sendMail.setEmailDeleteAt("N");
            sendMail.setEmailRealDeleteAt("N");
            sendMail.setEmailRedngAt("N");
            sendMail.setEmailReceivedEmplId(employeeVO.getEmplId());
            emailMapper.inputReceivedStatus(sendMail);

            mailSender.send(message);
            return "success";
        } catch (MessagingException | IOException e) {
            e.printStackTrace();
            return "fail";
        }
    }
}
