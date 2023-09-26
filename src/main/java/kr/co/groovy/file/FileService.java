package kr.co.groovy.file;

import kr.co.groovy.vo.UploadFileVO;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class FileService {
    final
    FileMapper mapper;

    public FileService(FileMapper mapper) {
        this.mapper = mapper;
    }

    UploadFileVO downloadFile(int uploadFileSn) {
        return mapper.downloadFile(uploadFileSn);
    }

    UploadFileVO downloadFileByDate(Map<String, String> map) {
        return mapper.downloadFileByDate(map);
    }

    List<UploadFileVO> downloadFileByDateForZip(Map<String, String> map) {
        return mapper.downloadFileByDateForZip(map);
    }

    void uploadFile(Map<String, Object> map) {
        mapper.uploadFile(map);
    }

}
