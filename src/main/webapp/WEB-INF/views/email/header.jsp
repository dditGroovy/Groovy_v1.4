<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header id="tab-header">
    <h1><a href="${pageContext.request.contextPath}/email/all" class="on">메일</a></h1>
</header>
<div class="mailnavWrap">
    <nav>
        <ul>
            <li class="mail"><a href="${pageContext.request.contextPath}/email/all">전체메일</a></li>
            <li class="mail"><a href="${pageContext.request.contextPath}/email/inbox">받은메일함</a></li>
            <li class="mail"><a href="${pageContext.request.contextPath}/email/sent">보낸메일함</a></li>
            <li class="mail"><a href="${pageContext.request.contextPath}/email/mine">내게쓴메일함</a></li>
<%--            <li class="mail"><a href="${pageContext.request.contextPath}/email/draft">임시저장함</a></li>--%>
            <li class="mail"><a href="${pageContext.request.contextPath}/email/trash">휴지통</a></li>
        </ul>
    </nav>
    <div id="search" class="search input-free-white">
        <input type="text" name="searchName" placeholder="제목을 입력하세요"/>
        <button type="submit" id="findMail" class="btn-search btn-flat btn">검색</button>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const currentPath = window.location.pathname;
        const target = document.querySelectorAll(".mailnavWrap nav a");

        target.forEach(link => {
            if (link.getAttribute("href") === currentPath) {
                link.classList.add("on");
            }
        });
    });

    const target = document.querySelectorAll(".mailnavWrap nav a");

    target.forEach(link => {
        link.addEventListener("click", function (event) {
            event.preventDefault(); // 기본 동작(페이지 이동) 막기

            target.forEach(item => {
                item.classList.remove("on");
            });

            link.classList.add("on");

            const href = link.getAttribute("href");
            if (href) {
                window.location.href = href;
            }
        });
    });
</script>
