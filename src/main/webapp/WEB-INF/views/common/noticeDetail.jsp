<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/resources/css/notice/notice.css" rel="stylesheet"/>
<style>
    .cke_contents{
        height: 100% !important;
        border: none !important;
    }
    .cke_chrome{
        border: none !important;
    }
    #cke_1_top, #cke_1_bottom{
        display: none !important;
    }
    .notice-content {
        display: none;
    }
</style>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/notice/list" class="on">공지사항</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div class="notice-card card-df">
                <div class="card-header notice-card-header">
                    <h2 class="main-title">${noticeDetail.notiTitle}</h2>
                    <div class="notice-view">
                        <p class="notice-date">
                            <fmt:formatDate value="${noticeDetail.notiDate}" pattern="yyyy년 MM월dd일"/>
                        </p>
                        <div class="box-view">
                            <span class="text-view-count"><fmt:formatNumber type="number"
                                                                            value="${noticeDetail.notiRdcnt}"
                                                                            pattern="#,##0"/> views</span>
                        </div>
                    </div>
                </div>
                <div class="card-body notice-card-body">
                    <div class="notice-content"><textarea id="editor" name="editor" disabled>${noticeDetail.notiContent}</textarea></div>
                    <c:if test="${notiFiles != null}">
                        <div class="notice-file">
                            <c:forEach var="notiFile" items="${notiFiles}" varStatus="stat">
                                <a href="/file/download/notice?uploadFileSn=${notiFile.uploadFileSn}"
                                   class="btn-free-white fileBox">${notiFile.uploadFileOrginlNm}
                                    <p><fmt:formatNumber value="${notiFile.uploadFileSize / 1024.0}"
                                                         type="number" minFractionDigits="1" maxFractionDigits="1"/>
                                        KB</p>
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/notice/list"
                       class="btn btn-fill-wh-sm back-btn">목록으로</a>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="/resources/ckeditor/ckeditor.js"></script>
<script>
    CKEDITOR.replace('editor', {
        on: {
            instanceReady: function (ev) {
                $(".notice-content").css("display", "block");
                // $("#editor").attr("disabled", true);
            }
        }
    });
</script>