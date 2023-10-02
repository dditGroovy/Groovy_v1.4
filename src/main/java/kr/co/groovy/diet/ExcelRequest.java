package kr.co.groovy.diet;

import java.io.File;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.web.multipart.MultipartFile;

public class ExcelRequest {
	String uploadPath;

	public ExcelRequest(String uploadPath) {
		this.uploadPath = uploadPath;
	}
	
	public ExcelRequest() {
	}

	public List<HashMap<String, String>> parseExcelMultiPart(Map<String, MultipartFile> files, 
	        String KeyString, int fileKeyParam, String atchFileId, String storePath) throws Exception {
	    List<HashMap<String, String>> list = new ArrayList<>();
	    
	    String storePathString = "";
	    String atchFileIdString = "";
	    
	    if ("".equals(storePath) || storePath == null) {
	        storePathString = uploadPath;
	    } else {
	        storePathString = uploadPath + storePath;
	    }
	 
	    if (!"".equals(atchFileId) || atchFileId != null) {
	        atchFileIdString = atchFileId;
	    }
	    
	    File saveFolder = new File(EgovWebUtil.filePathBlackList(storePathString));
	    
	    if (!saveFolder.exists() || saveFolder.isFile()) {
	        saveFolder.mkdirs();
	    }
	    
	    int fileKey = fileKeyParam;
	    
	    Iterator<Entry<String, MultipartFile>> iterator = files.entrySet().iterator();
	    
	    while (iterator.hasNext()) {
	        Entry<String, MultipartFile> entry = iterator.next();
	        
	        MultipartFile file = entry.getValue();
	        String orginFileName = file.getOriginalFilename();
	        
	        if ("".equals(orginFileName)) {
	            continue;
	        }
	        
	        int index = orginFileName.lastIndexOf(".");
	        String fileExt = orginFileName.substring(index + 1);
	        String newName = KeyString + fileKey;
	        
	        while (true) {
	            String filePath = storePathString + File.separator + newName + "." + fileExt;
	            File checkFile = new File(EgovWebUtil.filePathBlackList(filePath));
	            
	            if (!checkFile.exists()) {
	                break;
	            }
	            
	            fileKey++;
	            newName = KeyString + fileKey;
	        }
	        
	        String filePath = storePathString + File.separator + newName + "." + fileExt;
	        file.transferTo(new File(EgovWebUtil.filePathBlackList(filePath)));
	        
	        List<HashMap<String, String>> excelData = ExcelManagerXlsx.getInstance().getListXlsxRead(filePath);
	        
	        list.addAll(excelData);
	        
	        fileKey++;
	    }
	    return list;
	}
	
	
	public static class EgovWebUtil {
        public static String filePathBlackList(String value) {
            String returnValue = value;
            if (returnValue == null || returnValue.trim().equals("")) {
                return "";
            }

            returnValue = returnValue.replaceAll("\\.\\./", ""); 
            returnValue = returnValue.replaceAll("\\.\\.\\\\", "");

            return returnValue;
        }
    }
}