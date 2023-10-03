<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="contentWrap">
        <form action="#" method="post" id="mailForm" enctype="multipart/form-data">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="emailFromAddr" value="${CustomUser.employeeVO.emplEmail}">
            <input type="hidden" name="emailToAddr" value="${CustomUser.employeeVO.emplEmail}">
            <table border="1" style="width: 50%">
                <tr>
                    <th>제목</th>
                    <td>
                        <input type="text" name="emailFromSj" id="emailFromSj">
                    </td>
                </tr>
                <tr>
                    <th>파일첨부</th>
                    <td>
                        <input type="file" name="emailFiles" id="file" multiple>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <textarea id="editor" name="emailFromCn" required></textarea>
                    </td>
                </tr>
            </table>
            <div class="serviceWrap">
                <div class="serviceWrap">
                    <div class="writeWrap">
                        <button type="button" id="sendBtn">보내기</button>
                        <button type="button" id="saveBtn">임시저장</button>
                        <button type="button" id="resveBtn">예약</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</sec:authorize>
<script src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>
<script>
    let editor = CKEDITOR.replace("editor", {
        extraPlugins: 'notification'
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
                    alert("메일을 성공적으로 전송했습니다.");
                    location.href = "/email/all";
                } else {
                    alert("메일 전송에 실패했습니다. 다시 시도해주세요");
                }
            }
        }
        xhr.send(formData);
    });

</script>