<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="/resources/css/mail/mail.css" rel="stylesheet"/>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <jsp:include page="header.jsp"></jsp:include>
        <div class="contentWrap card card-df send-wrap">
            <div class="send-wrap-inner">
                <form action="#" method="post" id="mailForm" enctype="multipart/form-data">
                <input type="hidden" name="emailFromAddr" value="${CustomUser.employeeVO.emplEmail}">
                <input type="hidden" name="emailToAddr" value="${CustomUser.employeeVO.emplEmail}">
                <div class="serviceWrap">
                    <div class="writeWrap">
                        <button type="button" id="sendBtn" class="btn">보내기</button>
                        <a href="${pageContext.request.contextPath}/email/send" class="send-mine"><i class="icon i-change"></i>메일 쓰기</a>
                    </div>
                </div>
                <div class="content-body">
                    <div class="mail-write-options">
                        <div class="mail-title-wrap mail-write-option">
                            <h3><label for="emailFromSj">제목</label></h3>
                            <div class="option-wrap">
                                <input type="text" name="emailFromSj" id="emailFromSj" class="mail-input">
                            </div>
                        </div>
                        <div class="mail-file-wrap mail-write-option">
                            <h3><label for="file">파일 첨부</label></h3>
                            <div class="option-wrap">
                                <div class="file-wrap">
                                    <label for="file" class="btn btn-free-white file-btn">
                                        <i class="icon i-file"></i>
                                        내 PC
                                    </label>
                                    <input type="file" name="emailFiles" id="file" multiple  onchange="addFile(this);">
                                    <div class="file-list"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mail-write-editor">
                        <textarea id="editor" name="emailFromCn" required></textarea>
                    </div>
                </div>
            </form>
            </div>
        </div>
    </div>
</sec:authorize>
<script src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>
<script>
    /*  메일 헤더 가리기   */
    document.querySelector("#tab-header").style.display = "none";
    document.querySelector(".mailnavWrap #search").style.display = "none";

    let editor = CKEDITOR.replace("editor", {
        extraPlugins: 'notification',
        height : 320
    });

    document.querySelector("#sendBtn").addEventListener("click", function () {
        const mailForm = document.querySelector("#mailForm");
        let formData = new FormData(mailForm);
        formData.append("emailFromCn", editor.getData());

        let xhr = new XMLHttpRequest();
        xhr.open("post", "/email/send", true);
        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                if (xhr.responseText === "success") {
                    Swal.fire({
                        text: '메일을 성공적으로 전송했습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    location.href = "/email/all";
                } else {
                    Swal.fire({
                        text: '메일 전송을 실패했습니다 다시 시도해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            }
        }
        xhr.send(formData);
    });

    /*  파일 첨부   */
    let fileNo = 0;
    let filesArr = new Array();

    /* 첨부파일 추가 */
    function addFile(obj){
        let maxFileCnt = 5;   // 첨부파일 최대 개수
        let attFileCnt = document.querySelectorAll('.filebox').length;    // 기존 추가된 첨부파일 개수
        let remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
        let curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수

        // 첨부파일 개수 확인
        if (curFileCnt > remainFileCnt) {
            Swal.fire({
                text: '첨부파일은 최대 ' + maxFileCnt + '개 까지 첨부 가능합니다.',
                showConfirmButton: false,
                timer: 1500
            })
            alert("");
        } else {
            for (const file of obj.files) {
                // 첨부파일 검증
                if (validation(file)) {
                    let reader = new FileReader();
                    reader.onload = function () {
                        filesArr.push(file);
                    };
                    reader.readAsDataURL(file);

                    // 목록 추가
                    let htmlData = '';
                    htmlData += '<div id="file' + fileNo + '" class="filebox">';
                    htmlData += '   <p class="name">' + file.name + '</p>';
                    htmlData += '   <a class="delete" onclick="deleteFile(' + fileNo + ');"><i class="icon i-close"></i></a>';
                    htmlData += '</div>';
                    $('.file-list').append(htmlData);
                    fileNo++;
                } else {
                    continue;
                }
            }
        }
        // 초기화
        document.querySelector("input[type=file]").value = "";
    }
    /* 첨부파일 검증 */
    function validation(file){
        if (file.name.length > 100) {
            Swal.fire({
                text: '파일명이 100자 이상인 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else if (file.size > (100 * 1024 * 1024)) {
            Swal.fire({
                text: '최대 파일 용량인 100MB를 초과한 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else if (file.name.lastIndexOf('.') == -1) {
            Swal.fire({
                text: '확장자가 없는 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else {
            return true;
        }
    }
    /* 첨부파일 삭제 */
    function deleteFile(num) {
        document.querySelector("#file" + num).remove();
        filesArr[num].is_delete = true;
    }

</script>