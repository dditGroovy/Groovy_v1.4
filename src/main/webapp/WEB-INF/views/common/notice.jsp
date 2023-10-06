<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="/resources/css/notice/notice.css" rel="stylesheet"/>
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
                    <div class="date-wrap">
                        <input type="date" name="startDay" value="" class="selectBox input-date font-reg"/>
                        <input type="date" name="endDay" value="" class="selectBox input-date font-reg"/>
                    </div>
                    <div id="search" class="search input-free-white">
                        <input type="text" name="keyword" id="keywordInput" placeholder="검색어를 입력하세요." value="${param.keyword}"/>
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
                                <div class="notice-content">${noticeVO.notiContent}</div>
                            </div>
                            <div class="notice-footer">
                                <div class="box-view">
                                    <i class="icon i-view"></i>
                                    <span class="text-view-count font-11 color-font-md"><fmt:formatNumber type="number"
                                                                                                          value="${noticeVO.notiRdcnt}"
                                                                                                          pattern="#,##0"/> views</span>
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

        $("#keywordInput").click(function () {
            let currentInputValue = $(this).val();
            if (currentInputValue !== "") {
                $(this).val("");
            }
        });

        let today = new Date();

        const urlParams = new URLSearchParams(window.location.search);
        const startDayParam = urlParams.get("startDay");
        const endDayParam = urlParams.get("endDay");

        let startDayInput = $('input[name="startDay"]');
        let endDayInput = $('input[name="endDay"]');

        if (startDayParam && endDayParam) {
            startDayInput.val(startDayParam);
            endDayInput.val(endDayParam);
        } else {
            let oneMonthAgo = new Date(today);
            oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
            startDayInput.val(oneMonthAgo.toISOString().substr(0, 10));
            endDayInput.val(today.toISOString().substr(0, 10));
        }

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
            if (endDate > today) {
                endDayInput.val(today.toISOString().substr(0, 10));
            }
            if (startDate > endDate) {
                startDayInput.val(today.toISOString().substr(0, 10));
                endDayInput.val(today.toISOString().substr(0, 10));
            }
        });
    });
</script>











