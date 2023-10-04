package kr.co.groovy.chat;

import kr.co.groovy.employee.EmployeeMapper;
import kr.co.groovy.vo.ChatMemberVO;
import kr.co.groovy.vo.ChatRoomVO;
import kr.co.groovy.vo.ChatVO;
import kr.co.groovy.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Slf4j
@Service
public class ChatService {

    private final ChatMapper chatMapper;
    private final EmployeeMapper employeeMapper;

    public ChatService(ChatMapper chatMapper, EmployeeMapper employeeMapper) {
        this.chatMapper = chatMapper;
        this.employeeMapper = employeeMapper;
    }

    public List<EmployeeVO> loadEmpListForChat(String emplId) {
        return chatMapper.loadEmpListForChat(emplId);
    }

    public List<ChatRoomVO> loadChatRooms(String emplId) {
        return chatMapper.loadChatRooms(emplId);
    }

    public int inputMessage(ChatVO message) {
        return chatMapper.inputMessage(message);
    }

    public List<ChatVO> loadRoomMessages(int chttRoomNo) {
        return chatMapper.loadRoomMessages(chttRoomNo);
    }

    public List<String> loadRoomMembers(int chttRoomNo) {
        return chatMapper.loadRoomMembers(chttRoomNo);
    }

    public String loadNewRoomName(int chttRoomNo) {
        return chatMapper.loadNewRoomName(chttRoomNo);
    }

    int inviteEmpl(Map<String, Object> newMem) {
        int chttRoomNo = Integer.parseInt(newMem.get("chttRoomNo").toString());
        String chttRoomNm = (String) newMem.get("chttRoomNm");
        List<String> newMemIdList = (List<String>) newMem.get("employees");
        int newMemCnt = newMemIdList.size();
        int result = 0;
        for(String emplId : newMemIdList) {
            ChatMemberVO chatMemberVO = new ChatMemberVO();
            chatMemberVO.setChttRoomNo(chttRoomNo);
            chatMemberVO.setChttMbrEmplId(emplId);
            result = chatMapper.inviteEmpl(chatMemberVO);
        }
        if(result == 1) {
            Pattern pattern = Pattern.compile("\\d+");
            Matcher matcher = pattern.matcher(chttRoomNm);
            while(matcher.find()) {
                int currentNum = Integer.parseInt(matcher.group());
                int newNum = currentNum + newMemCnt;
                String newName = chttRoomNm.replace(Integer.toString(currentNum), Integer.toString(newNum));
                ChatRoomVO chatRoomVO = new ChatRoomVO();
                chatRoomVO.setChttRoomNo(chttRoomNo);
                chatRoomVO.setChttRoomNm(newName);
                result = chatMapper.modifyRoomNm(chatRoomVO);
            }
        }
        return result;
    }

    int createRoom(String emplId, List<EmployeeVO> roomMemList) {
        EmployeeVO hostEmpl = employeeMapper.loadEmp(emplId);

        roomMemList.add(0, hostEmpl);

        int chttRoomNmpr = roomMemList.size();

        int checkDuplication = 0;
        int result = 0;

        String chttRoomTy = null;
        String chttRoomNm = null;
        if (chttRoomNmpr == 2) {
            chttRoomTy = "0";
            chttRoomNm = roomMemList.stream().map(EmployeeVO::getEmplNm).collect(Collectors.joining(", "));

            Map<String, String> mbrData = new HashMap<>();
            int count = 1;
            for (EmployeeVO employeeVO : roomMemList) {
                String chttMbrEmplId = employeeVO.getEmplId();
                mbrData.put("emplId" + count, chttMbrEmplId);
                count++;
            }
            checkDuplication = chatMapper.checkDuplication(mbrData);

        } else if (chttRoomNmpr > 2) {
            chttRoomTy = "1";
            chttRoomNm = hostEmpl.getEmplNm() + " 외 " + (chttRoomNmpr - 1) + "인";
        }

        if(checkDuplication == 0) {
            Map<String, Object> roomData = new HashMap<>();
            roomData.put("chttRoomNm", chttRoomNm);
            roomData.put("chttRoomTy", chttRoomTy);
            roomData.put("chttRoomNmpr", chttRoomNmpr);
            result = chatMapper.inputChatRoom(roomData);
            if (result == 1) {
                for (EmployeeVO employeeVO : roomMemList) {
                    String chttMbrEmplId = employeeVO.getEmplId();
                    result = chatMapper.inputChatMember(chttMbrEmplId);
                }
            }
        }
        return result;
    }

}
