package kr.co.groovy.file;

import kr.co.groovy.vo.UploadFileVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface FileMapper {
    UploadFileVO downloadFile(int uploadFileSn);

    UploadFileVO downloadFileByDate(Map<String, String> map);
    List<UploadFileVO> downloadFileByDateForZip(Map<String, String> map);

    void uploadFile(Map<String, Object> map);
}
