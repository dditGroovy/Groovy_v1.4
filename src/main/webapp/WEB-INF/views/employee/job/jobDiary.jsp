<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="/resources/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/job/job.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/job/main">할 일</a></h1>
        <h1><a href="${pageContext.request.contextPath}/job/jobDiary" class="on">업무 일지</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div id="inProgress" class="card-df">
                <button type="button" id="goWrite" class="btn btn-out-sm">업무 일지 작성</button>
                <table class="form approval-form">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>등록자</th>
                        <th>등록일</th>
                    </tr>
                    </thead>
                    <tbody>
                <c:choose>
                    <c:when test="${empty list}">
                        <tr><td rowspan="4"> 데이터가 존재하지 않습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                                <c:forEach var="jobDiaryVO" items="${list}" varStatus="stat">
                                    <tr>
                                        <td>${stat.index + 1}</td>
                                        <td>
                                            <a href="/job/read?date=${jobDiaryVO.jobDiaryReportDate.substring(0, 10)}&id=${jobDiaryVO.jobDiaryWrtingEmplId}" class="link">
                                                    ${jobDiaryVO.jobDiarySbj}
                                            </a>
                                        </td>
                                        <td>${jobDiaryVO.jobDiaryWrtingEmplNm}</td>
                                        <td><c:out value="${jobDiaryVO.jobDiaryReportDate.substring(0, 10)}"/></td>
                                    </tr>
                                </c:forEach>

                    </c:otherwise>
                </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
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