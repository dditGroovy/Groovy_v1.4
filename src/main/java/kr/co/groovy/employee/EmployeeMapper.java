package kr.co.groovy.employee;

import kr.co.groovy.vo.ConnectionLogVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.NotificationVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface EmployeeMapper {
    EmployeeVO signIn(String emplId);

    void initMacAddr(@Param("emplMacadrs") String emplMacadrs, @Param("emplId") String emplId);

    void initPassword(@Param("emplId") String emplId, @Param("emplPassword") String emplPassword);

    int countEmp();

    void inputEmp(EmployeeVO vo);

    List<EmployeeVO> loadEmpList();

    List<EmployeeVO> findEmp(@Param("depCode") String depCode, @Param("emplNm") String emplNm, @Param("sortBy") String sortBy);

    EmployeeVO findById(String id);

    List<EmployeeVO> loadBirthday();

    EmployeeVO loadEmp(String emplId);

    void modifyProfile(@Param("emplId") String emplId, @Param("fileName") String fileName, @Param("originalFileName") String originalFileName);

    void modifyPassword(@Param("emplId") String emplId, @Param("emplPassword") String emplPassword);

    void modifySign(@Param("emplId") String emplId, @Param("fileName") String fileName, @Param("originalFileName") String originalFileName);

    NotificationVO getNoticeAt(String emplId);

    void modifyEmp(EmployeeVO vo);

    void modifyNoticeAt(Map<String, Object> map);

    void inputConectLog(ConnectionLogVO vo);
    List<ConnectionLogVO> loadConnectionLog(String date);

    String findTelNoByEmplId(String emplId);

    List<String> loadEmplByDept(String commonCodeDept);
}

