<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link href="/resources/css/common.css" rel="stylesheet"/>
<link href="/resources/css/job/orgChart.css" rel="stylesheet"/>
<sec:authorize access="isAuthenticated()">
  <sec:authentication property="principal" var="CustomUser" />
<div id="orgChart" class="orgBorder">
  <ul id="hrt">
    <li class="department on"><a href="#">인사팀</a>
      <ul>
      <c:forEach var="hrtList" items="${DEPT010List}">
        <c:if test="${CustomUser.employeeVO.emplId ne hrtList.emplId}">
          <li>
            <label for="${hrtList.emplId}">
              <input type="checkbox" name="orgCheckbox" id="${hrtList.emplId}" class="employees">
              <span>${hrtList.emplNm}</span>
              <span>${hrtList.commonCodeClsf}</span>
            </label>
          </li>
        </c:if>
      </c:forEach>
      </ul>
    </li>
  </ul>
  <ul id="at">
    <li class="department"><a href="#">회계팀</a>
      <ul>
      <c:forEach var="atList" items="${DEPT011List}">
        <c:if test="${CustomUser.employeeVO.emplId ne atList.emplId}">
          <li>
            <label for="${atList.emplId}">
              <input type="checkbox" name="orgCheckbox" id="${atList.emplId}" class="employees">
              <span>${atList.emplNm}</span>
              <span>${atList.commonCodeClsf}</span>
            </label>
          </li>
        </c:if>
      </c:forEach>
      </ul>
    </li>
  </ul>
  <ul id="st">
    <li class="department"><a href="#">영업팀</a>
    <ul>
      <c:forEach var="stList" items="${DEPT012List}">
        <c:if test="${CustomUser.employeeVO.emplId ne stList.emplId}">
          <li>
            <label for="${stList.emplId}">
              <input type="checkbox" name="orgCheckbox" id="${stList.emplId}" class="employees">
              <span>${stList.emplNm}</span>
              <span>${stList.commonCodeClsf}</span>
            </label>
          </li>
        </c:if>
      </c:forEach>
      </ul>
    </li>
  </ul>
  <ul id="prt">
    <li class="department"><a href="#">홍보팀</a>
    <ul>
      <c:forEach var="prtList" items="${DEPT013List}">
        <c:if test="${CustomUser.employeeVO.emplId ne prtList.emplId}">
          <li>
            <label for="${prtList.emplId}">
              <input type="checkbox" name="orgCheckbox" id="${prtList.emplId}" class="employees">
              <span>${prtList.emplNm}</span>
              <span>${prtList.commonCodeClsf}</span>
            </label>
          </li>
        </c:if>
      </c:forEach>
    </ul>
    </li>
  </ul>
  <ul id="gat">
    <li class="department"><a href="#">총무팀</a>
    <ul>
    <c:forEach var="gatList" items="${DEPT014List}">
      <c:if test="${CustomUser.employeeVO.emplId ne gatList.emplId}">
        <li>
          <label for="${gatList.emplId}">
            <input type="checkbox" name="orgCheckbox" id="${gatList.emplId}" class="employees">
            <span>${gatList.emplNm}</span>
            <span>${gatList.commonCodeClsf}</span>
          </label>
      </c:if>
    </c:forEach>
    </ul>
    </li>
  </ul>
  <div class="btn-wrap">
    <button type="button" id="orgCancel" class="btn btn-free-white">취소</button>
    <button type="button" id="orgCheck" class="btn btn-free-blue">확인</button>
  </div>
</div>
</sec:authorize>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
  /*  조직도 */
  const area = $("#orgChart");
  area.on("click",".department > a",function(){
    $(".department").removeClass("on");
    $(this).parent(".department").toggleClass("on");
  })
  $("#orgCancel").click(()=>{
    window.close();
  })
</script>