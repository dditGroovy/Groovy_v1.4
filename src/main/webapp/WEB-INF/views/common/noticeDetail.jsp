<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
    .box-sort-search {
        margin-top: calc((18 / var(--vh)) * 100vh);
        margin-bottom: calc((32 / var(--vh)) * 100vh);
        display: flex;
        justify-content: flex-end;
        align-items: center;
    }

    select {
        margin-right: calc((24 / var(--vw)) * 100vw);
        width: calc((148 / var(--vw)) * 100vw);
        height: var(--vh-32);
        border: 1px solid var(--color-stroke);
    }

    .box-search {
        width: calc((560 / var(--vw)) * 100vw);
        height: var(--vh-64);
        padding-left: var(--vw-24);
        padding-right: var(--vw-24);
        display: flex;
        justify-content: space-between;
        align-items: center;
        border: 1px solid var(--color-stroke);
    }

    .icon-search-24 {
        width: var(--vw-18);
        height: var(--vw-18);
    }

    .input-search {
        border: none;
    }

    .btn-search {
        width: calc((87 / var(--vw)) * 100vw);
        height: calc((37 / var(--vh)) * 100vh);
    }

    .box-notices {
        display: grid;
        grid-template-columns: repeat(3, calc((476 / var(--vw)) * 100vw));
        grid-gap: var(--vw-24) var(--vh-24);
    }

    .box-notice {
        width: calc((476 / var(--vw)) * 100vw);
        height: calc((346 / var(--vh)) * 100vh);

    }


</style>
<div class="content-container">
    <h1 class="font-36 font-md color-font-high">공지사항</h1>
    <div class="box-notices">

        <div class="box-notice card-df">
            <p>${noticeDetail.notiTitle}</p>
            <p>${noticeDetail.notiContent}</p>
            <div class="box-view-date">
                <div class="box-view">
                    <i class="icon icon-view-24"></i>
                    <span class="text-view-count">${noticeDetail.notiRdcnt}</span> view
                </div>
                <div class="box-date">
                    ${noticeDetail.notiDate}
                </div>
                <c:if test="${notiFiles != null}">
                    <c:forEach var="notiFile" items="${notiFiles}" varStatus="stat">
                        <%--                <p><a href="/common/fileDownload?uploadFileSn=${notiFile.uploadFileSn}">${notiFile.uploadFileOrginlNm}</a>--%>
                        <p>
                            <a href="/file/download/notice?uploadFileSn=${notiFile.uploadFileSn}">${notiFile.uploadFileOrginlNm}</a>
                            <fmt:formatNumber value="${notiFile.uploadFileSize / 1024.0}"
                                              type="number" minFractionDigits="1" maxFractionDigits="1"/> KB</p>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>
</div>

