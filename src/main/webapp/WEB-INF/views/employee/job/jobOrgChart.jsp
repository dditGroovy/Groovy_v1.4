<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="isAuthenticated()">
  <sec:authentication property="principal" var="CustomUser" />
<div id="orgChart" class="orgBorder">
  <ul id="hrt">
    <li>인사팀</li>
    <c:forEach var="hrtList" items="${DEPT010List}">
      <c:if test="${CustomUser.employeeVO.emplId ne hrtList.emplId}">

        <li>
          <label for="${hrtList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${hrtList.emplId}">
            <span>${hrtList.emplNm}</span>
            <span>${hrtList.commonCodeClsf}</span>
          </label>
        </li>
      </c:if>
    </c:forEach>
  </ul>
  <ul id="at">
    <li>회계팀</li>
    <c:forEach var="atList" items="${DEPT011List}">
      <c:if test="${CustomUser.employeeVO.emplId ne atList.emplId}">
        <li>
          <label for="${atList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${atList.emplId}">
            <span>${atList.emplNm}</span>
            <span>${atList.commonCodeClsf}</span>
          </label>
        </li>
      </c:if>
    </c:forEach>
  </ul>
  <ul id="st">
    <li>영업팀</li>
    <c:forEach var="stList" items="${DEPT012List}">
      <c:if test="${CustomUser.employeeVO.emplId ne stList.emplId}">
        <li>
          <label for="${stList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${stList.emplId}">
            <span>${stList.emplNm}</span>
            <span>${stList.commonCodeClsf}</span>
          </label>
        </li>
      </c:if>
    </c:forEach>
  </ul>
  <ul id="prt">
    <li>홍보팀</li>
    <c:forEach var="prtList" items="${DEPT013List}">
      <c:if test="${CustomUser.employeeVO.emplId ne prtList.emplId}">
        <li>
          <label for="${prtList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${prtList.emplId}">
            <span>${prtList.emplNm}</span>
            <span>${prtList.commonCodeClsf}</span>
          </label>
        </li>
      </c:if>
    </c:forEach>
  </ul>
  <ul id="gat">
    <li>총무팀</li>
    <c:forEach var="gatList" items="${DEPT014List}">
      <c:if test="${CustomUser.employeeVO.emplId ne gatList.emplId}">
        <li>
          <label for="${gatList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${gatList.emplId}">
            <span>${gatList.emplNm}</span>
            <span>${gatList.commonCodeClsf}</span>
          </label>
        </li>
      </c:if>
    </c:forEach>
  </ul>

  <button type="button" id="orgCheck">확인</button>
  <button type="button" id="orgCancel">취소</button>
</div>
</sec:authorize>