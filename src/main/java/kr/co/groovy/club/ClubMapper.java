package kr.co.groovy.club;

import kr.co.groovy.vo.ClubMbrVO;
import kr.co.groovy.vo.ClubVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ClubMapper {
    List<ClubVO> loadAllClub(String clbConfmAt);
    List<ClubVO> loadClub(Map<String, Object> map);
    List<ClubVO> loadProposalList();
    List<ClubVO> loadRegistList();
    ClubVO loadClubDetail(String clbEtprCode);
    List<ClubMbrVO> loadClubMbr(String clbEtprCode);
    int getSeq();
    void inputClub(Map<String, Object> map);
    void updateClubAt(Map<String, Object> map);
    void inputClubMbr(Map<String, Object> map);
    int updateClubMbrAct(Map<String, Object> map);
    void updateClubInfo(ClubVO vo);
}
