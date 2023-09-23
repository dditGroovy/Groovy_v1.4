<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .content-header {
        margin-bottom: var(--vh-32);
    }

    .notice-inner {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: var(--vw-24);
    }

    .box-notice {
        height: calc((346 / 1080) * 100vh);
    }

    .box-notice > a {
        display: flex;
        flex-direction: column;
        width: 100%;
        height: 100%;
        padding: var(--vw-32);
    }

    .notice-header {
        margin-bottom: var(--vh-24);
    }

    .notice-body {
        display: flex;
        flex-direction: column;
        gap: var(--vh-24);
    }

    .notice-title {
        font-family: var(--font-sb);
        font-size: var(--font-size-24);
        color: var(--color-font-high);
    }

    .notice-content {
        font-size: var(--font-size-18);
        color: var(--color-font-md);
    }

    .notice-body {
        flex: 1;
    }

    .notice-icon > img {
        width: var(--vw-48);
        height: var(--vw-48);
        object-fit: cover;
    }

    .notice-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .box-view {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: var(--vw-10);
    }

    .box-view i.icon {
        width: var(--vw-24);
        height: var(--vw-24);
    }

</style>

<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/notice/loadNoticeList" class="on">공지사항</a></h1>
    </header>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="box-sort-search">
                <form action="${pageContext.request.contextPath}/notice/find" method="get">
                    <div class="select-wrapper">
                        <select name="sortBy" id="" class="stroke selectBox">
                            <option value="DESC">최신순</option>
                            <option value="ASC">오래된순</option>
                        </select>
                    </div>
                    <div class="">
                        <input type="date" name="startDay" value=""/>
                        <input type="date" name="endDay" value=""/>
                    </div>
                    <div id="search" class="search input-free-white">
                        <input type="text" name="keyword" placeholder="검색어를 입력하세요." value="${param.keyword}"/>
                        <button type="submit" class="btn-search btn-flat btn">검색</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="content-body">
            <div class="notice-inner">
                <c:forEach var="noticeVO" items="${noticeList}" varStatus="stat">
                    <div class="box-notice card-df">
                        <a href="/notice/detail/${noticeVO.notiEtprCode}">
                            <div class="notice-icon notice-header"><img
                                    src="/resources/images/${noticeVO.notiCtgryIconFileStreNm}"></div>
                            <div class="notice-body">
                                <h3 class="notice-title">${noticeVO.notiTitle}</h3>
                                <p class="notice-content">${noticeVO.notiContent}</p>
                            </div>
                            <div class="notice-footer">
                                <div class="box-view">
                                    <i class="icon i-view"></i>
                                    <span class="text-view-count font-11 color-font-md">${noticeVO.notiRdcnt} views</span>
                                </div>
                                <div class="box-date">
                                    <span class="font-11 color-font-md">${noticeVO.notiDate}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>

        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        let today = new Date();

        let oneMonthAgo = new Date(today);
        oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
        let startDayInput = $('input[name="startDay"]');
        startDayInput.val(oneMonthAgo.toISOString().substr(0, 10));

        let endDayInput = $('input[name="endDay"]');
        endDayInput.val(today.toISOString().substr(0, 10));

        startDayInput.on('change', function () {
            let startDate = new Date(startDayInput.val());
            let endDate = new Date(endDayInput.val());

            if (startDate > endDate) {
                startDayInput.val(today.toISOString().substr(0, 10));
                endDayInput.val(today.toISOString().substr(0, 10));
            }
        });

        endDayInput.on('change', function () {
            let startDate = new Date(startDayInput.val());
            let endDate = new Date(endDayInput.val());

            if (startDate > endDate) {
                startDayInput.val(today.toISOString().substr(0, 10));
                endDayInput.val(today.toISOString().substr(0, 10));
            }
        });
    });
</script>











