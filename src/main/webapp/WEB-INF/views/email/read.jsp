<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .content-header {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .mail-option {
        display: flex;
        gap: 24px;
    }

    .file-attachment-title, .file-attachment-inner {
        display: flex;
        align-items: center;
        gap: 24px;
    }

    .mail-list-item, .mail-list-title, .toggle-mail-chk {
        display: flex;
        align-items: center;
        gap: 12px;
    }
</style>
<jsp:include page="header.jsp"/>
<div class="cotentWrap">
    <div class="content-header">
        <button class="button-back">뒤로</button>
        <h2 class="mail-title">
            <a href="/email/inbox">받은 메일함</a>
            <p><c:out value="${unreadMailCount}"/></p>
            <p><c:out value="${allMailCount}"/></p>
        </h2>
        <div class="button-wrap">
            <button class="delete" data-id="<c:out value="${emailVO.emailEtprCode}"/>"
                    data-at="<c:out value="${emailVO.emailDeleteAt}"/>">삭제
            </button>
        </div>
    </div>
    <div class="content-body">
        <div class="mail-view">
            <div class="mail-header">
                <h3 class="mail-title">
                    <span class="title"><c:out value="${emailVO.emailFromSj}"/> </span>
                    <c:set var="sendDateStr" value="${emailVO.emailFromSendDate}"/>
                    <fmt:formatDate var="sendDate" value="${sendDateStr}" pattern="yyyy년 MM월 dd일 (EE) HH:mm"/>
                    <p class="mail-date">${sendDate}</p>
                </h3>
                <div class="mail-options">
                    <div class="mail-option-sender mail-option">
                        <div class="title">보낸 사람</div>
                        <div class="content">
                            <button class="button-sender button-option">
                                <c:out value="${emailVO.emailFromNm}"/> &lt;<c:out value="${emailVO.emailFromAddr}"/>&gt;
                            </button>
                        </div>
                    </div>
                    <div class="mail-option-receiver mail-option">
                        <div class="title">받은 사람</div>
                        <div class="content">
                            <c:forEach var="emailTo" items="${toList}">
                                <button class="button-receiver button-option">${emailTo.emailToNm}
                                    &lt;${emailTo.emailToAddr}&gt;
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                    <c:if test="${ccList != [null]}">
                        <div class="mail-option-carbonCopy mail-option">
                            <div class="title">참조</div>
                            <div class="content">
                                <c:forEach items="${ccList}" var="emailCc">
                                    <button class="button-carbonCopy button-option">${emailCc.emailCcNm}
                                        &lt;${emailCc.emailCcAddr}&gt;
                                    </button>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="mail-body">
                <div class="mail-view">
                    <div class="mail-content">
                        <p id="emailFromCn"><input type="hidden" value='<c:out value="${emailVO.emailFromCn}"/>'></p>
                    </div>
                </div>
            </div>
            <div class="mail-footer">
            </div>
        </div>
    </div>
</div>
<script>
    document.querySelector(".delete").addEventListener("click", function () {
        let emailEtprCode = document.querySelector(".delete").getAttribute("data-id");
        let at = document.querySelector(".delete").getAttribute("data-at");
        let code = "delete";
        let xhr = new XMLHttpRequest();
        xhr.open("put", `/email/\${code}/\${emailEtprCode}`, true);
        xhr.onreadystatechange = function () {
            if (xhr.status == 200 && xhr.readyState == 4) {
                alert("해당 메일을 휴지통으로 이동했습니다.");
                location.href = "/email/all";
            }
        }
        xhr.send(at);
    })

    window.onload = function () {
        let contentType = `<c:out value="${emailVO.emailFromCnType}"/>`;
        let content = document.querySelector("input[type=hidden]").value;
        if (contentType.includes("text/html")) {
            document.querySelector("#emailFromCn").innerHTML = content;
        } else {
            document.querySelector("#emailFromCn").innerText = content;
        }
    }
</script>