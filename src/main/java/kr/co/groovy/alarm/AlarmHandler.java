package kr.co.groovy.alarm;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.*;

@Slf4j
public class AlarmHandler extends TextWebSocketHandler {
    //로그인 한 전체
    List<WebSocketSession> sessions = new ArrayList<>();

    //1:1
    Map<String, WebSocketSession> userSessionMap = new HashMap<>();

    final EmployeeService service;

    public AlarmHandler(EmployeeService service) {
        this.service = service;
    }

    //서버 접속성공
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        log.info("현재 접속한 사원 id: {}", currentUserId(session));
        String senderId = currentUserId(session);
        userSessionMap.put(senderId, session);
    }

    //현재 접속 사원
    private String currentUserId(WebSocketSession session) {
        String loginUserId;
        if (session.getPrincipal() == null || session == null) {
            loginUserId = null;
        } else {
            loginUserId = session.getPrincipal().getName();
        }
        return loginUserId;
    }

    //소켓에 메시지 보냈을 때
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String msg = message.getPayload();
        if (msg != null) {
            String[] msgs = msg.split(",");
            String seq = msgs[0];
            String category = msgs[1];
            String url = msgs[2];

            if (category.equals("noti")) {//공지사항
                for (WebSocketSession webSocketSession : sessions) {
                    String userId = currentUserId(webSocketSession);
                    NotificationVO noticeAt = service.getNoticeAt(userId);
                    String companyNotice = noticeAt.getCompanyNotice();

                    if (webSocketSession != null && webSocketSession.isOpen() && companyNotice.equals("NTCN_AT010")) {
                        String notificationHtml = String.format(
                                "<a href=\"%s\" data-seq=\"%s\" id=\"fATag\">" +
                                    "<div class=\"alarm-textbox\">" +
                                        "<p>[전체공지] 관리자로부터 전체 공지사항이 등록되었습니다.</p>" +
                                    "</div>" +
                                "</a>"
                                ,
                                url, seq
                        );
                        webSocketSession.sendMessage(new TextMessage(notificationHtml));
                    }
                }
            } else if (category.equals("teamNoti")) {//팀커뮤니티 - 팀공지사항
                String sendName = msgs[3];
                String deptName = msgs[4];
                String registId = msgs[5];
                List<String> emplIdList = service.loadEmplByDept(deptName);
                for (WebSocketSession webSocketSession : sessions) {
                    String userId = currentUserId(webSocketSession);
                    for (String emplId : emplIdList) {
                        if (emplId.equals(userId) && !emplId.equals(registId)) {
                            NotificationVO noticeAt = service.getNoticeAt(userId);
                            String teamNotice = noticeAt.getTeamNotice();

                            if (webSocketSession != null && webSocketSession.isOpen() && teamNotice.equals("NTCN_AT010")) {
                                String notificationHtml = String.format(
                                        "<a href=\"%s\" data-seq=\"%s\" id=\"fATag\">" +
                                                "<div class=\"alarm-textbox\"><p>[팀 커뮤니티] %s님이 팀 공지사항을 등록하셨습니다.</p></div>" +
                                        "</a>"
                                        ,
                                        url, seq, sendName
                                );
                                webSocketSession.sendMessage(new TextMessage(notificationHtml));
                            }
                        }
                    }
                }
            } else if (category.equals("answer")) {//팀커뮤니티 - 댓글
                String sendName = msgs[3];
                String receiveId = msgs[4];
                String subject = msgs[5];
                WebSocketSession receiveSession = userSessionMap.get(receiveId);
                NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                if (receiveSession != null && receiveSession.isOpen() && noticeAt.getAnswer().equals("NTCN_AT010")) {
                    String notificationHtml = String.format(
                            "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                "<h1>[팀 커뮤니티]</h1>" +
                                "<div class=\"alarm-textbox\">" +
                                "<p>[<span>%s</span>]에 " +
                                "%s님이 댓글을 등록하셨습니다.</p>" +
                                "</div>" +
                            "</a>",
                            url, seq, subject, sendName
                    );
                    receiveSession.sendMessage(new TextMessage(notificationHtml));
                }
            } else if (category.equals("job")) {//업무
                String sendName = msgs[3];
                String subject = msgs[4];
                String[] selectedEmplIdsArray = Arrays.copyOfRange(msgs, 5, msgs.length);
                for (String emplId : selectedEmplIdsArray) {
                    WebSocketSession receiveSession = userSessionMap.get(emplId);
                    NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                    if (receiveSession != null && receiveSession.isOpen() && noticeAt.getDutyRequest().equals("NTCN_AT010")) {
                        String notificationHtml = String.format(
                                "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                    "<h1>[업무 요청]</h1>\n" +
                                    "<div class=\"alarm-textbox\">" +
                                        "<p>%s님이 " +
                                        "<span>%s</span>" +
                                        "업무를 요청하셨습니다.</p>" +
                                    "</div>" +
                                "</a>",
                                url, seq, sendName, subject
                        );
                        receiveSession.sendMessage(new TextMessage(notificationHtml));
                    }
                }
            } else if (category.equals("chat")) {
                String sendName = msgs[3];
                String[] selectedEmplIdsArray = Arrays.copyOfRange(msgs, 4, msgs.length);
                for (String emplId : selectedEmplIdsArray) {
                    WebSocketSession receiveSession = userSessionMap.get(emplId);
                    NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                    if (receiveSession != null && receiveSession.isOpen() && noticeAt.getNewChattingRoom().equals("NTCN_AT010")) {
                        String notificationHtml = String.format(
                                "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                    "<h1>[채팅]</h1>" +
                                    "<div class=\"alarm-textbox\"" +
                                        "<p>%s님이 채팅방에 초대하셨습니다.</p>" +
                                    "</div>" +
                                "</a>",
                                url, seq, sendName
                        );
                        receiveSession.sendMessage(new TextMessage(notificationHtml));
                    }
                }
            } else if (category.equals("email")) {
                String subject = msgs[3];
                String[] selectedEmplIdsArray = Arrays.copyOfRange(msgs, 4, msgs.length);
                for (String emplId : selectedEmplIdsArray) {
                    WebSocketSession receiveSession = userSessionMap.get(emplId);
                    NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                    if (receiveSession != null && receiveSession.isOpen() && noticeAt.getEmailReception().equals("NTCN_AT010")) {
                        String notificationHtml = String.format(
                                "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                        "<h1>[메일]</h1>" +
                                        "<p>[<span>%s</span>]" +
                                        " 메일이 도착했습니다.</p>" +
                                        "</a>",
                                url, seq, subject
                        );
                        receiveSession.sendMessage(new TextMessage(notificationHtml));
                    }
                }
            } else if (category.equals("card")) {
                String receiveId = msgs[3];
                WebSocketSession receiveSession = userSessionMap.get(receiveId);
                if (receiveSession != null && receiveSession.isOpen()) {
                    String notificationHtml = String.format(
                            "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                "<h1>[법인카드 신청]</h1>\n" +
                                "<div class=\"alarm-textbox\">" +
                                    "<p>법인카드 신청이 승인되었습니다.</p>" +
                                "</div>" +
                            "</a>",
                            url, seq
                    );
                    receiveSession.sendMessage(new TextMessage(notificationHtml));
                }
            } else if (category.equals("sign")) {
                String receiveId = msgs[3];
                WebSocketSession receiveSession = userSessionMap.get(receiveId);
                if (receiveSession != null && receiveSession.isOpen()) {
                    String notificationHtml = String.format(
                            "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                "<h1>[서명 등록 요청]</h1>" +
                                "<div class=\"alarm-textbox\">" +
                                    "<p>내 정보 관리에서 서명을 등록해주세요.</p>" +
                                "</div>" +
                            "</a>",
                            url, seq
                    );
                    receiveSession.sendMessage(new TextMessage(notificationHtml));
                }
            } else if (category.equals("sanctionReception")) {
                String sendName = msgs[3];
                String title = msgs[4];
                String[] selectedEmplIdsArray = Arrays.copyOfRange(msgs, 5, msgs.length);
                for (String emplId : selectedEmplIdsArray) {
                    WebSocketSession receiveSession = userSessionMap.get(emplId);
                    NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                    if (receiveSession != null && receiveSession.isOpen() && noticeAt.getElectronSanctionReception().equals("NTCN_AT010")) {
                        String notificationHtml = String.format(
                                "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                    "<h1>[결재 요청]</h1>" +
                                    "<div class=\"alarm-textbox\">" +
                                        "<p>%s님이 " +
                                        "[<span>%s</span>]" +
                                        "결재를 요청하셨습니다.</p>" +
                                    "</div>" +
                                "</a>",
                                url, seq, sendName, title
                        );
                        receiveSession.sendMessage(new TextMessage(notificationHtml));
                    }
                }
            } else if (category.equals("sanctionResult")) {
                String sendName = msgs[3];
                String receiveId = msgs[4];
                String title = msgs[5];
                String status = msgs[6];
                WebSocketSession receiveSession = userSessionMap.get(receiveId);
                NotificationVO noticeAt = service.getNoticeAt(currentUserId(receiveSession));
                if (receiveSession != null && receiveSession.isOpen() && noticeAt.getElectronSanctionResult().equals("NTCN_AT010")) {
                    String notificationHtml = String.format(
                            "<a href=\"%s\" id=\"fATag\" data-seq=\"%s\">" +
                                "<div class=\"alarm-textbox\">" +
                                "<h1>[결재 결과]</h1>" +
                                "<p>%s님이" +
                                "[<span>%s</span>] 결재를" +
                                "%s하셨습니다.</p>" +
                                "</div>" +
                            "</a>",
                            url, seq, sendName, title, status
                    );
                    receiveSession.sendMessage(new TextMessage(notificationHtml));
                }
            }
        }
    }

    //연결 해제될 때
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
        userSessionMap.remove(currentUserId(session), session);
    }
}
