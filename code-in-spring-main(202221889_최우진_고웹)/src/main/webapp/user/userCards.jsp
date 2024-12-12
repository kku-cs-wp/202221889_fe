<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.ac.kku.cs.wp.wsd.user.entity.User" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<div id="user-count" style="margin-bottom: 20px;">전체 :<strong>${fn:length(requestScope.users)}</strong></div>
	
	<div class="user-card-container" id="user-list">
	
	<c:forEach var="user" items="${users}"  >
	    <!-- 사용자 카드 1 (여러 역할 및 사번 추가) -->
	    <div class="user-card" data-name="홍길동" data-email="hong@example.com" data-role="관리자, 개발자" data-id="1001">
	        <c:if test="${ user.photo == null}" > 
	        <img src="https://via.placeholder.com/150" alt="홍길동 사진">
	        </c:if>
	        <c:if test="${ user.photo != null}" > 
	        <img src="${pageContext.request.contextPath}/uploads/${user.photo}" alt="${user.name}">
	        </c:if>
	        <div class="user-info">
	            <h3>${user.name}</h3>
	            <p><strong>이메일:</strong>${user.email }</p>
	            <p><strong>역할:</strong>  <c:forEach var="userRole" items="${user.userRoles}">
                        ${userRole.role.role}&nbsp;
                    </c:forEach></p>
	            <p><strong>사번:</strong> ${user.id }</p>
	            <p><strong>상태:</strong> ${user.status}</p>
	            <button onclick="showUserDetail('${user.id }')">상세 보기</button>
	        </div>
	    </div>
	</c:forEach>
	</div>