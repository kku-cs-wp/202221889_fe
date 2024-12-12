<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>



<div class="viewcontainer">
	<h2>사용자 정보</h2>

	<!-- 서버 에러 메시지 표시 -->
	<div id="server-error" class="error"></div>
	<!-- 서버 성공 메시지 표시 -->
	<div id="server-success" class="success"></div>

	<div class="viewuser-info">
		<div class="viewinfo-item">
			<label>ID:</label> <span>${user.id}</span>
		</div>
		<div class="viewinfo-item">
			<label>이름:</label> <span>${user.name}</span>
		</div>
		<div class="viewinfo-item">
			<label>이메일:</label> <span>${user.email}</span>
		</div>
		<div class="viewinfo-item">
			<label>상태:</label> <span>${user.status}</span>
		</div>
		<div class="viewinfo-item">
			<label>역할:</label> <span> <c:forEach var="userRole"
					items="${user.userRoles}">
					${userRole.role.role}&nbsp;
				</c:forEach>
			</span>
		</div>
		<div class="viewinfo-item">
			<label>사진:</label>
			<div class="viewimage-preview">
				<img src="${pageContext.request.contextPath}/uploads/${user.photo}"
					alt="사용자 사진" />
			</div>
		</div>
	</div>

	<div class="viewbuttons">
		<button class="viewedit-btn" onclick="editUser('${user.id}')">수정</button>
		<button class="viewdelete-btn" onclick="confirmDelete('${user.id}', '${user.name}')">삭제</button>
	</div>
</div>

<script>
//폼 데이터 전송 함수
async function editUser(userId) {
    
	const formData = new URLSearchParams();
    formData.append('userId', userId);

    // 서버 응답에 따른 메시지 표시를 위한 요소
    const serverError = document.getElementById('server-error');
    const serverSuccess = document.getElementById('server-success');
    serverError.textContent = ''; // 이전 에러 메시지 초기화
    serverSuccess.textContent = ''; // 이전 성공 메시지 초기화

    try {
        const response = await fetch('user/edit', {
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

async function confirmDelete(userId) {
    if (confirm('정말로 삭제하시겠습니까?')) {
    	const formData = new URLSearchParams();
        formData.append('id', userId);

        const response = await fetch('user/delete', {
            method: 'POST',
            body: formData
        });

        const isOk = response.ok;
        const data = await response.text();

        if (isOk) {
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
        	 openModalFetch(data); 
        }
        
    }
}
</script>
<style>
/* 기본 스타일 */ 
body {
	font-family: 'Roboto', sans-serif;
	background-color: #f2f2f2;
	margin: 0;
	padding: 0;
}

/* 컨테이너 스타일 */
.viewcontainer {
	max-width: 800px;
	margin: 50px auto;
	background-color: #ffffff;
	padding: 40px 50px;
	border-radius: 8px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

/* 헤더 스타일 */
h2 {
	text-align: center;
	margin-bottom: 40px;
	font-weight: 500;
	color: #333;
}

/* 사용자 정보 스타일 */
.viewuser-info {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.viewinfo-item {
	display: flex;
	align-items: center;
}

.viewinfo-item label {
	flex: 0 0 120px;
	font-weight: 500;
	color: #555;
}

.viewinfo-item span {
	flex: 1;
	color: #333;
	font-size: 16px;
	background-color: #f9f9f9;
	padding: 8px 12px;
	border-radius: 4px;
}

/* 이미지 스타일 */
.viewimage-preview {
	flex: 1;
}

.viewimage-preview img {
	max-width: 100%;
	height: auto;
	border-radius: 8px;
	border: 1px solid #ddd;
}

/* 버튼 스타일 */
.viewbuttons {
	text-align: center;
	margin-top: 30px;
}

.viewbuttons button {
	padding: 12px 30px;
	margin: 0 10px;
	font-size: 16px;
	cursor: pointer;
	border: none;
	border-radius: 6px;
	transition: background-color 0.3s ease;
}

.viewedit-btn {
	background-color: #4CAF50;
	color: white;
}

.viewedit-btn:hover {
	background-color: #45a049;
}

.viewdelete-btn {
	background-color: #f44336;
	color: white;
}

.viewdelete-btn:hover {
	background-color: #da190b;
}

/* 반응형 디자인 */
@media ( max-width : 600px) {
	.viewinfo-item {
		flex-direction: column;
		align-items: flex-start;
	}
	.viewinfo-item label {
		margin-bottom: 5px;
	}
	.viewbuttons button {
		width: 100%;
		margin-bottom: 10px;
	}
}
</style>

</style>