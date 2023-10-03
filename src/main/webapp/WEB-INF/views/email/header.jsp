<%--
  Created by IntelliJ IDEA.
  User: Ha-Neul Yun
  Date: 2023-08-30
  Time: 오후 3:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header id="tab-header">
    <h1><a href="${pageContext.request.contextPath}/email/all" class="on">메일</a></h1>
</header>
<div class="mailnavWrap">
    <nav>
        <ul>
            <li class="mail"><a href="/email/all">전체메일</a></li>
            <li class="mail"><a href="/email/inbox">받은메일함</a></li>
            <li class="mail"><a href="/email/sent">보낸메일함</a></li>
            <li class="mail"><a href="/email/mine">내게쓴메일함</a></li>
            <li class="mail"><a href="/email/draft">임시저장함</a></li>
            <li class="mail"><a href="/email/trash">휴지통</a></li>
        </ul>
    </nav>
    <form action="#" method="get">
        <div class="search">
            <input type="text" name="searchName">
            <button id="findMail">검색</button>
        </div>
    </form>
</div>
