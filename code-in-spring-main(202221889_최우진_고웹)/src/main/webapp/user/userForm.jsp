<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 로딩 오버레이 -->
<div id="loading-overlay" class="loading-overlay">
	<div class="spinner"></div>
</div>

<div class="container">
	<h2>사용자 등록</h2>

	<!-- 서버 에러 메시지 표시 -->
	<div id="server-error" class="error"></div>
	<!-- 서버 성공 메시지 표시 -->
	<div id="server-success" class="success"></div>

	<form id="user-form" enctype="multipart/form-data" method="post"
		action="${pageContext.request.contextPath}/user/create">
		<!-- ID 필드 (자동 생성) -->
		<div class="form-group">
			<label for="id">ID:</label> <input type="text" id="id" name="id"
				readonly="readonly" value="자동 생성됨" />
		</div>

		<!-- 이름 필드 -->
		<div class="form-group">
			<label for="name">이름:</label> <input type="text" id="name"
				name="name" required />
			<div id="name-error" class="error"></div>
		</div>

		<!-- 이메일 필드 -->
		<div class="form-group">
			<label for="email">이메일:</label> <input type="email" id="email"
				name="email" required />
			<div id="email-error" class="error"></div>
		</div>

		<!-- 비밀번호 필드 -->
		<div class="form-group password-field">
			<label for="password">비밀번호:</label> <input type="password"
				id="password" name="password" required /> <span
				id="toggle-password" class="toggle-password"
				onclick="togglePasswordVisibility()">👁</span>
			<div id="password-error" class="error"></div>
		</div>

		<!-- 상태 필드 (라디오 버튼) -->
		<div class="form-group">
			<label for="status">상태:</label> <select id="status" name="status"
				required>
				<option value="">선택해주세요</option>
				<option value="재직중">재직중</option>
				<option value="퇴직">퇴직</option>
			</select>
			<div id="status-error" class="error"></div>
		</div>

		<!-- 사진 업로드 필드 -->
		<div class="form-group">
			<label for="photo">사진 업로드:</label>
			<div class="custom-file-input">
				<label class="custom-file-label" for="photo">파일 선택</label> <input
					type="file" id="photo" name="photoFile"
					onchange="previewImage(event)" accept="image/*" />
			</div>
			<!-- 이미지 미리보기 -->
			<div class="image-preview">
				<img id="image-preview" src="#" alt="이미지 미리보기" />
			</div>
		</div>

		<!-- 역할 선택 (최대 2개 선택 가능) -->
		<div class="form-group">
			<label>역할 선택 (최대 2개):</label>
			<div class="roles-group">
				<label> 관리자 <input type="checkbox"
					name="roleId" value="1000" />
				</label> <label> 개발자 <input type="checkbox"
					name="roleId" value="1001" />
				</label> <label> 시스템 관리자 <input type="checkbox"
					name="roleId" value="1002" />
				</label>
			</div>
		</div>

		<button type="submit" onclick="submitForm()">회원 가입</button>
	</form>
</div>
<style>
/* 기본 스타일 */
body {
	font-family: 'Arial', sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f8f9fa;
}

/* 컨테이너 스타일 */
.container {
	max-width: 600px;
	margin: 50px auto;
	background-color: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
	position: relative;
	z-index: 1;
}

/* 제목 스타일 */
.container h2 {
	text-align: center;
	margin-bottom: 30px;
}

/* 라벨과 입력 필드 스타일 */
.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
}

.form-group input, .form-group select {
	width: 100%;
	padding: 12px;
	box-sizing: border-box;
	font-size: 16px;
	border: 1px solid #ced4da;
	border-radius: 4px;
}

/* 파일 입력 필드 스타일 */
.form-group input[type="file"] {
	padding: 10px;
	background-color: white;
	border: none;
	cursor: pointer;
}

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

/* 버튼 스타일 */
button[type="submit"] {
	width: 100%;
	padding: 14px;
	background-color: #28a745;
	color: white;
	border: none;
	border-radius: 5px;
	font-size: 18px;
	cursor: pointer;
}

button[type="submit"]:hover {
	background-color: #218838;
}

button[disabled] {
	background-color: #6c757d;
	cursor: not-allowed;
}

/* 역할 선택 체크박스 스타일 */
.roles-group {
	display: flex;
	flex-wrap: wrap;
}

.roles-group label {
	width: 48%;
	margin-bottom: 10px;
	display: flex;
	align-items: center;
	font-size: 16px;
}

.roles-group input[type="checkbox"] {
	margin-left: 10px;
	width: 18px;
	height: 18px;
}

/* 사진 업로드 미리보기 스타일 */
.image-preview {
	margin-top: 10px;
}

.image-preview img {
	max-width: 100%;
	height: auto;
}

/* 비밀번호 입력 필드 아이콘 스타일 */
.password-field {
	position: relative;
}

.password-field input[type="password"], .password-field input[type="text"]
	{
	width: 100%;
	padding-right: 40px;
}

.password-field .toggle-password {
	position: absolute;
	top: 50%;
	right: 10px;
	transform: translateY(-50%);
	cursor: pointer;
}

/* 파일 선택 버튼 스타일 */
.custom-file-input {
	position: relative;
	overflow: hidden;
	display: inline-block;
	width: 100%;
}

.custom-file-input input[type="file"] {
	position: absolute;
	top: 0;
	right: 0;
	margin: 0;
	padding: 0;
	font-size: 100px;
	cursor: pointer;
	opacity: 0;
	filter: alpha(opacity = 0);
}

.custom-file-label {
	display: block;
	padding: 12px;
	border: 1px solid #ced4da;
	border-radius: 4px;
	background-color: white;
	cursor: pointer;
	text-align: center;
}

/* 로딩 오버레이 스타일 */
.loading-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(255, 255, 255, 0.7);
	z-index: 9999;
	display: none;
	align-items: center;
	justify-content: center;
}

.spinner {
	border: 8px solid #f3f3f3;
	border-top: 8px solid #28a745;
	border-radius: 50%;
	width: 60px;
	height: 60px;
	animation: spin 1s linear infinite;
}

@
keyframes spin { 0% {
	transform: rotate(0deg);
}
100
%
{
transform
:
rotate(
360deg
);
}
}
</style>

<!-- 스크립트 -->
<script>
    /* document.addEventListener('DOMContentLoaded', function() {
        // 폼 제출 이벤트 리스너
        const form = document.getElementById('user-form');
        form.addEventListener('submit', function(event) {
            event.preventDefault(); // 폼의 기본 제출 동작 방지
            submitForm();
        });

        // 실시간 입력 검증 함수 호출
        validateInput();
    }); */

   // const form = document.getElementById('user-form');
    document.getElementById('user-form').addEventListener('submit', function(event) {
        event.preventDefault(); // 폼의 기본 제출 동작 방지
        submitForm();
    });

    // 실시간 입력 검증 함수 호출
    validateInput();

    // 실시간 입력 검증 함수
    function validateInput() {
        // 이름 검증: 특수문자 사용 불가
        const nameInput = document.getElementById('name');
        const nameError = document.getElementById('name-error');
        const namePattern = /^[\p{L}\p{M}\p{N} ]*$/u;

        nameInput.addEventListener('input', function() {
            if (!namePattern.test(nameInput.value)) {
                nameError.textContent = '특수문자를 사용할 수 없습니다.';
            } else {
                nameError.textContent = '';
            }
        });

        // 이메일 검증: 이메일 형식 확인
        const emailInput = document.getElementById('email');
        const emailError = document.getElementById('email-error');

        emailInput.addEventListener('input', function() {
            if (!emailInput.validity.valid) {
                emailError.textContent = '유효한 이메일 주소를 입력해주세요.';
            } else {
                emailError.textContent = '';
            }
        });

        // 비밀번호 검증: 특수문자, 영문자, 숫자를 포함하여 8자리 이상
        const passwordInput = document.getElementById('password');
        const passwordError = document.getElementById('password-error');
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[~`!@#$%^&*()_\-+=\[\]{}|\\;:'",.<>\/?]).{8,}$/;

        passwordInput.addEventListener('input', function() {
            if (!passwordPattern.test(passwordInput.value)) {
                passwordError.textContent = '비밀번호는 특수문자, 영문자, 숫자를 포함하여 8자리 이상이어야 합니다.';
            } else {
                passwordError.textContent = '';
            }
        });
    }

    

    // 폼 데이터 전송 함수
    async function submitForm() {
        const form = document.getElementById('user-form');
        const formData = new FormData(form);

        var roleIds = formData.getAll("roleId");

        for (var i = 0; i < roleIds.length; i++) {
			  formData.append('userRoles[' + i + '].roleId', roleIds[i])
        }
        formData.delete('roleId');



        let isValid = true;

        // 이름 검증: 특수문자 사용 불가
        const nameInput = document.getElementById('name');
        const nameError = document.getElementById('name-error');
        const namePattern = /^[\p{L}\p{M}\p{N} ]*$/u;

        if (nameInput.value.trim() === '') {
            nameError.textContent = '이름을 입력해주세요.';
            isValid = false;
        } else if (!namePattern.test(nameInput.value)) {
            nameError.textContent = '특수문자를 사용할 수 없습니다.';
            isValid = false;
        } else {
            nameError.textContent = '';
        }

        // 이메일 검증: 이메일 형식 확인
        const emailInput = document.getElementById('email');
        const emailError = document.getElementById('email-error');

        if (emailInput.value.trim() === '') {
            emailError.textContent = '이메일을 입력해주세요.';
            isValid = false;
        } else if (!emailInput.validity.valid) {
            emailError.textContent = '유효한 이메일 주소를 입력해주세요.';
            isValid = false;
        } else {
            emailError.textContent = '';
        }

        // 비밀번호 검증: 특수문자, 영문자, 숫자를 포함하여 8자리 이상
        const passwordInput = document.getElementById('password');
        const passwordError = document.getElementById('password-error');
        const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[~`!@#$%^&*()_\-+=\[\]{}|\\;:'",.<>\/?]).{8,}$/;

        if (passwordInput.value.trim() === '') {
            passwordError.textContent = '비밀번호를 입력해주세요.';
            isValid = false;
        } else if (!passwordPattern.test(passwordInput.value)) {
            passwordError.textContent = '비밀번호는 특수문자, 영문자, 숫자를 포함하여 8자리 이상이어야 합니다.';
            isValid = false;
        } else {
            passwordError.textContent = '';
        }

        if (!isValid) {
           return;
        }
    

        // 서버 응답에 따른 메시지 표시를 위한 요소
        const serverError = document.getElementById('server-error');
        const serverSuccess = document.getElementById('server-success');
        serverError.textContent = ''; // 이전 에러 메시지 초기화
        serverSuccess.textContent = ''; // 이전 성공 메시지 초기화

        // 로딩 오버레이 표시 및 버튼 비활성화
        showLoading();
        disableForm();

        try {
           const response = await fetch(form.action, {
                method: 'POST',
                body: formData
            });

            const contentType = response.headers.get('content-type');
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
        } catch (error) {
            console.log('error occur:' + error);
        } finally {
        	// 로딩 오버레이 숨김 및 폼 활성화
            hideLoading();
            enableForm();
        }
    }

    // 로딩 오버레이 표시 함수
    function showLoading() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay)
        	overlay.style.display = 'flex';
    }

    // 로딩 오버레이 숨김 함수
    function hideLoading() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay)
        overlay.style.display = 'none';
    }

    // 폼 비활성화 함수
    function disableForm() {
        const form = document.getElementById('user-form');
        if (form) {
        	const elements = form.elements;
            for (let i = 0; i < elements.length; i++) {
                elements[i].disabled = true;
            }
        }
        
    }

    // 폼 활성화 함수
    function enableForm() {
    	const form = document.getElementById('user-form');
        if (form) {
        	const elements = form.elements;
	        for (let i = 0; i < elements.length; i++) {
	            elements[i].disabled = false;
	        }
        }
    }

    // 비밀번호 표시 토글 기능
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('toggle-password');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.innerText = '🙈'; // 눈 가린 원숭이 아이콘
        } else {
            passwordInput.type = 'password';
            toggleIcon.innerText = '👁'; // 눈 아이콘
        }
    }

    // 이미지 미리보기 함수
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function(){
            const output = document.getElementById('image-preview');
            output.src = reader.result;
        };
        if (event.target.files[0]) {
            reader.readAsDataURL(event.target.files[0]);
        }
    }
</script>
