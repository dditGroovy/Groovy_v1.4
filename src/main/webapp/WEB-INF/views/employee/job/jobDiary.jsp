<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="/resources/ckeditor/ckeditor.js"></script>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/job/main">할 일</a></h1>
        <h1><a href="${pageContext.request.contextPath}/job/jobDiary" class="on">업무 일지</a></h1>
    </header>
    <button type="button" id="goWrite">업무 일지 작성</button>
    <c:choose>
        <c:when test="${empty list}">
            <p>데이터가 존재하지 않습니다.</p>
        </c:when>
        <c:otherwise>
            <table border="1">
                <tr>
                    <td>번호</td>
                    <td>제목</td>
                    <td>등록자</td>
                    <td>등록일</td>
                </tr>
                <c:forEach var="jobDiaryVO" items="${list}" varStatus="stat">
                    <tr>
                        <td>${stat.index + 1}</td>
                        <td>
                            <a href="/job/read?date=${jobDiaryVO.jobDiaryReportDate.substring(0, 10)}&id=${jobDiaryVO.jobDiaryWrtingEmplId}">
                                    ${jobDiaryVO.jobDiarySbj}
                            </a>
                        </td>
                        <td>${jobDiaryVO.jobDiaryWrtingEmplNm}</td>
                        <td><c:out value="${jobDiaryVO.jobDiaryReportDate.substring(0, 10)}"/></td>
                    </tr>
                </c:forEach>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<script>
    let goWrite = document.querySelector("#goWrite");
    goWrite.addEventListener("click", function () {
        window.location.href = "/job/write";
    });

    //업무 등록 실패했을시
    let error = `${error}`;
    if (error != "") {
        alert(error);
    }

</script>