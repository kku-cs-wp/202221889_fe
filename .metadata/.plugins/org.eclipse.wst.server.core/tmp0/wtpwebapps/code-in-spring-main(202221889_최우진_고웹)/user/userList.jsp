<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.ac.kku.cs.wp.wsd.user.entity.User" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<h2>사용자 목록</h2>

<!-- 서버 에러 메시지 표시 -->
 <div id="server-error" class="error"></div>
 <!-- 서버 성공 메시지 표시 -->
 <div id="server-success" class="success"></div>

<!-- 필터 입력 필드 -->
<div class="filter-container">
    <input type="text" id="user-filter" placeholder="이름, 이메일, 역할 또는 사번으로 검색" >
    <button onclick="filterUsers()">검색</button> 
</div>

<div id="refresh">
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
</div>

<script>
    // 사용자 필터링 함수
    function filterUsers() {
        const filterValue = document.getElementById('user-filter').value.toLowerCase();
        // filter({'id':filterValue, 'name':filterValue, 'email':filterValue, 'status':filterValue, 'userRoles':[{'roleName':filterValue}]});
        filter(filterValue);
    }

 	// 페이지를 로드하고 카드를 동적으로 생성하는 함수
    async function filter(queryString) {
        const mainContent = document.getElementById('refresh');
        const formData = new URLSearchParams();
        formData.append("queryString", queryString);
        
        // POST 요청을 보내면서 파라미터를 전달
        const response = await fetch('user/search', {
            method: 'POST',
            body : formData
            /* headers: {
                'Content-Type': 'application/json',  // JSON 형식으로 전달
            },
            body: JSON.stringify(params),  // 파라미터를 JSON으로 변환하여 body에 추가 */
        });
        
        const isOk = response.ok;
        const data = await response.text();

        if (!isOk) {
            openModalFetch(data);  // 오류 발생 시 모달 창 호출
        } else {
        	mainContent.innerHTML = data;
        }
    }

    // 폼 데이터 전송 함수
    async function showUserDetail(userId) {
        
    	const formData = new URLSearchParams();
        formData.append('userId', userId);

        // 서버 응답에 따른 메시지 표시를 위한 요소
        const serverError = document.getElementById('server-error');
        const serverSuccess = document.getElementById('server-success');
        serverError.textContent = ''; // 이전 에러 메시지 초기화
        serverSuccess.textContent = ''; // 이전 성공 메시지 초기화

        try {
            const response = await fetch('user/view', {
                method: 'POST',
                body: formData
            });

            const contentType = response.headers.get('content-type');
            
            if (response.ok) {
            	if (contentType && contentType.includes('text/html')) {
            		const data = await response.text();
					const pageId = 'user';
                	//loadPage 참조
                	const mainContent = document.querySelector('main');
                	const existingPage = document.getElementById(pageId);
                	if (existingPage)
                		existingPage.remove(); //before appending new Page

                	const newPageCard = document.createElement('div');
    	            newPageCard.id = pageId;
    	            newPageCard.classList.add('page-card');
    	            newPageCard.innerHTML = data;
    	            mainContent.appendChild(newPageCard);
    	            setActivePage(pageId);
    	            adjustPaddingForHome(pageId);
    	            
    	            // 페이지 내 script 태그 재실행 처리
    	            const scripts = newPageCard.getElementsByTagName('script');
    	            Array.from(scripts).forEach((script, i) => {
    	                /* const scriptId = `${pageId}_script_${i}`; */
    	                const scriptId = pageId + '_script_' + i;
    	                console.log(pageId + '_script_' + i);
    	                const existingScript = document.getElementById(scriptId);
    	                if (existingScript) existingScript.remove();
    	                
    	                const newScript = document.createElement('script');
    	                newScript.id = scriptId;
    	                newScript.text = script.text;
    	                document.body.appendChild(newScript);
    	            });
            	} else {
            		const errorData = await response.json();
                    if (errorData && errorData.message) {
                        serverError.textContent = errorData.message;
                    } else {
                        serverError.textContent = '회원 가입 중 오류가 발생했습니다.';
                    }
                }
            } else {
                const errorData = await response.json();
                if (errorData && errorData.message) {
                    serverError.textContent = errorData.message;
                } else {
                    serverError.textContent = '회원 가입 중 오류가 발생했습니다.';
                }
            }
        } catch (error) {
            console.error('에러 발생:', error);
            serverError.textContent = '서버와 통신 중 에러가 발생했습니다.';
         	
            
        } 
    }

    
</script>

<style>
    /* 에러 메시지 스타일 */
    .error {
        color: red;
        font-size: 14px;
        margin-top: 5px;
    }

    /* 성공 메시지 스타일 */
    .success {
        color: green;
        font-size: 16px;
        margin-top: 10px;
        text-align: center;
    }
    
    .filter-container {
	    margin-bottom: 20px;
	    display: flex;
	    align-items: center; /* 필드와 버튼을 나란히 배치 */
	}
	
	.filter-container input {
	    width: 90%;
	    padding: 10px;
	    font-size: 16px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    margin-right: 10px; /* 버튼과 간격 추가 */
	}
	
	.filter-container button {
	    padding: 10px 20px;
	    font-size: 16px;
	    background-color: #007bff;
	    color: white;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	}
	
	.filter-container button:hover {
	    background-color: #0056b3;
	}


    .user-card-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); /* 카드 크기를 좁게 설정 */
        gap: 20px;
    }

    .user-card {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        text-align: center;
        transition: transform 0.3s ease;
        width: 180px; /* 카드 폭을 좁게 */
        height: 300px; /* 카드 높이를 길게 */
    }

    .user-card:hover {
        transform: scale(1.05);
    }

    .user-card img {
        width: 100%;
        height: 150px; /* 이미지 높이 늘림 */
        object-fit: cover;
    }

    .user-info {
        padding: 10px;
        font-size: 14px;
    }

    .user-info h3 {
        font-size: 16px;
        margin-bottom: 10px;
        color: #007bff;
    }

    .user-info p {
        font-size: 12px;
        color: #333;
        line-height : 0;
        margin-bottom : 15px;
    }

    .user-info button {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 12px;
        margin-top: 10px;
    }

    .user-info button:hover {
        background-color: #0056b3;
    }

    /* 반응형 디자인 */
    @media (max-width: 768px) {
        .user-card-container {
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); /* 작은 화면에서 더 좁게 */
        }

        .user-info h3 {
            font-size: 14px;
        }

        .user-info p {
            font-size: 11px;
        }

        .user-info button {
            font-size: 10px;
        }
    }
</style>