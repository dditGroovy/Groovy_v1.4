package kr.co.groovy.chat;

import kr.co.groovy.vo.ChatMemberVO;
import kr.co.groovy.vo.ChatRoomVO;
import kr.co.groovy.vo.ChatVO;
import kr.co.groovy.vo.EmployeeVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMapper {

    List<EmployeeVO> loadEmpListForChat(String emplId);

    int inputChatRoom(Map<String, Object> roomData);

    int inputChatMember(String emplId);

    int checkDuplication(Map<String, String> mbrData);

    List<ChatRoomVO> loadChatRooms(String emplId);

    int inputMessage(ChatVO message);

    List<ChatVO> loadRoomMessages(int chttRoomNo);

    List<String> loadRoomMembers(int chttRoomNo);

    int inviteEmpl(ChatMemberVO chatMemberVO);

    int modifyRoomNm(ChatRoomVO chatRoomVO);

    String loadNewRoomName(int chttRoomNo);

}