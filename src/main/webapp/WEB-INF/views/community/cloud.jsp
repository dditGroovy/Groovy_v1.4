<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="/resources/css/community/cloud.css">
<div class="content-container">
    <header id="tab-header">
        <div class="header">
            <h1><a href="#" class="on">클라우드</a></h1>
            <p class="font-reg font-18">팀원들과 클라우드에서 만나요☁️</p>
        </div>
    </header>
    <div class="cloud">
        <div class="button-wrapper">
            <button class="addFolder btn btn-free-blue btn-cloud font-md font-14"><i class="icon i-folder"></i>폴더 생성</button>
            <button class="uploadFile btn btn-free-blue btn-cloud font-md font-14"><i class="icon i-download"></i>올리기</button>
        </div>
        <div class="cloud-wrapper">
            <div class="file-wrapper">
                <c:forEach var="folder" items="${folderList}">
                    <div class="folder-box cursor-box">
                        <i class="icon-img folder-img"></i>
                        <p class="font-md font-14">${folder}</p>
                    </div>
                </c:forEach>
                <c:forEach var="file" items="${fileList}">
                    <c:set var="fileParts" value="${fn:split(file.key, '.')}"/>
                    <c:set var="extension" value="${fileParts[1]}"/>
                    <c:set var="extensionToIcon" value="${extensionList}"/>
                    <c:set var="iconClass" value="${extensionToIcon[extension]}" />

                    <div class="file-box cursor-box" data-key="${file.storageClass}" onclick="fileInfo(this)">
                        <c:choose>
                            <c:when test="${empty iconClass}">
                                <i class="icon-img other-img"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="icon-img ${iconClass}" style="background: url('/resources/images/cloud/${iconClass}.png') no-repeat;"></i>
                            </c:otherwise>
                        </c:choose>
                        <p class="font-md font-14">${fileParts[0]}</p>
                    </div>
                </c:forEach>
            </div>
            <div class="cloud-preview">
                <h1 class="content-name"></h1>
                <p><img src="" alt=""></p>
                <div>
                    <p>유형</p>
                    <p class="content-type"></p>
                </div>
                <div>
                    <p>마지막 수정</p>
                    <p class="last-date"></p>
                </div>
                <div>
                    <p>크기</p>
                    <p class="content-size"></p>
                </div>
                <div>
                    <p>공유한 사람</p>
                    <p class="share-person"></p>
                </div>
                <button type="button">삭제</button>
            </div>
        </div>
    </div>
</div>

<script>
    function fileInfo(infoBox) {
        let key = infoBox.getAttribute("data-key");
        let filename = infoBox.querySelector("p").innerText;
        console.log(filename)
        $.ajax({
            type: 'get',
            url: `/cloud/fileInfo?key=\${key}`,
            success: function (fileInfo) {
                console.log(fileInfo);
                document.querySelector(".content-name").innerText = filename;
                document.querySelector(".content-type").innerText = fileInfo.type;
                document.querySelector(".content-size").innerText = fileInfo.size;
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        })
    }

</script>