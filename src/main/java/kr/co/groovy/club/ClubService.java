package kr.co.groovy.club;

import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.ClubMbrVO;
import kr.co.groovy.vo.ClubVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
@Slf4j
@Service
public class ClubService {
    final ClubMapper mapper;

    public ClubService(ClubMapper mapper) {this.mapper = mapper;}

    public List<ClubVO> loadAllClub(String clbConfmAt){return mapper.loadAllClub(clbConfmAt);}
    public List<ClubVO> loadClub(Map<String, Object> map){return mapper.loadClub(map);}
    public List<ClubVO> loadProposalList(){return mapper.loadProposalList();}
    public List<ClubVO> loadRegistList(){return mapper.loadRegistList();}
    public ClubVO loadClubDetail(String clbEtprCode){
        ClubVO clubVO = mapper.loadClubDetail(clbEtprCode);
        List<ClubMbrVO> clubMbrList = mapper.loadClubMbr(clbEtprCode);
        for (ClubMbrVO vo : clubMbrList) {
            vo.setClbMbrDept(Department.valueOf(vo.getClbMbrDept()).label());
            vo.setClbMbrClsf(ClassOfPosition.valueOf(vo.getClbMbrClsf()).label());
        }
        clubVO.setClubMbr(clubMbrList);
        return clubVO;
    }
    public void inputClub(Map<String, Object> map){
        String clbEtprCode = makeSntncEtprCode();
        map.put("clbEtprCode",clbEtprCode);
        mapper.inputClub(map);
    }
    public void updateClubAt(Map<String, Object> map){mapper.updateClubAt(map);}
    public void inputClubMbr(Map<String, Object> map){
        mapper.inputClubMbr(map);
    };
    public int updateClubMbrAct(Map<String, Object> map){
        return mapper.updateClubMbrAct(map);
    };
    public void updateClubInfo(ClubVO vo){mapper.updateClubInfo(vo);}
    public String makeSntncEtprCode(){
        int clubSeq = mapper.getSeq();
        /*'SNTNC-'||SNTNC_SEQ.nextval||'-'||TO_CHAR(sysdate,'yyyyMMdd')*/
        // 현재 날짜 구하기
        // 날짜 포맷팅
        String clbEtprCode = "clb-" + clubSeq;
        return clbEtprCode;
    }
}
