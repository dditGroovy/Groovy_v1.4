<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/orgChart/orgChart.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/common/orgChart" class="on">조직도</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div id="ceo" class="department-wrap">
                <h2 class="department">CEO</h2>
                <div class="department-list ceo-list">
                    <c:forEach var="dept015" items="${DEPT015List}" varStatus="stat">
                        <img src="/uploads/profile/${dept015.proflPhotoFileStreNm}" class="empl-profile">
                        <div>
                            <h3 class="ceoName">${dept015.emplNm}</h3>
                            <p style="font-size: 14px;">대표이사</p>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="content-wrap">
                <div class="department-wrap">
                    <h2 class="department">인사팀</h2>
                    <ol class="department-list">
                        <c:forEach var="dept010" items="${DEPT010List}" varStatus="stat">
                            <li>
                                <div class="empl-info">
                                    <img src="/uploads/profile/${dept010.proflPhotoFileStreNm}" class="empl-profile">
                                    <div>
                                        <h3 class="empl-name">${dept010.emplNm}</h3> <span
                                            class="empl-clsf">${dept010.commonCodeClsf}</span>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
                <div class="department-wrap">
                    <h2 class="department">회계팀</h2>
                    <ol class="department-list">
                        <c:forEach var="dept011" items="${DEPT011List}" varStatus="stat">
                            <li>
                                <div class="empl-info">
                                    <img src="/uploads/profile/${dept011.proflPhotoFileStreNm}" class="empl-profile">
                                    <div>
                                        <h3 class="empl-name">${dept011.emplNm}</h3> <span
                                            class="empl-clsf">${dept011.commonCodeClsf}</span>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
                <div class="department-wrap">
                    <h2 class="department">영업팀</h2>
                    <ol class="department-list">
                        <c:forEach var="dept012" items="${DEPT012List}" varStatus="stat">
                            <li>
                                <div class="empl-info">
                                    <img src="/uploads/profile/${dept012.proflPhotoFileStreNm}" class="empl-profile">
                                    <div>
                                        <h3 class="empl-name">${dept012.emplNm}</h3> <span
                                            class="empl-clsf">${dept012.commonCodeClsf}</span>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
                <div class="department-wrap">
                    <h2 class="department">홍보팀</h2>
                    <ol class="department-list">
                        <c:forEach var="dept013" items="${DEPT013List}" varStatus="stat">
                            <li>
                                <div class="empl-info">
                                    <img src="/uploads/profile/${dept013.proflPhotoFileStreNm}" class="empl-profile">
                                    <div>
                                        <h3 class="empl-name">${dept013.emplNm}</h3> <span
                                            class="empl-clsf">${dept013.commonCodeClsf}</span>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
                <div class="department-wrap">
                    <h2 class="department">총무팀</h2>
                    <ol class="department-list">
                        <c:forEach var="dept014" items="${DEPT014List}" varStatus="stat">
                            <li>
                                <div class="empl-info">
                                    <img src="/uploads/profile/${dept014.proflPhotoFileStreNm}" class="empl-profile">
                                    <div>
                                        <h3 class="empl-name">${dept014.emplNm}</h3> <span
                                            class="empl-clsf">${dept014.commonCodeClsf}</span>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
            </div>
        </div>
    </main>
</div>