<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공모전 다모아</title>
<link
	href="https://fonts.googleapis.com/css?family=Roboto:400,500&display=swap"
	rel="stylesheet">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Arial', sans-serif;
	background-color: #f0f4f8;
	margin: 0;
	padding: 0;
}

/* 헤더 스타일 수정 */
header {
	background-color: #2a9df4;
	color: white;
	padding: 10px 20px; /* 여백을 적당하게 설정 */
	text-align: left; /* 왼쪽 정렬 */
	display: flex;
	justify-content: space-between; /* 양 끝 정렬 */
	align-items: center; /* 세로 가운데 정렬 */
	font-size: 20px;
	font-weight: bold;
}

/* 메뉴 버튼 스타일 */
header button {
	background-color: white;
	border: none;
	padding: 8px 16px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 18px;
	color: #007bff;
}

/* 메뉴 버튼 호버 효과 */
header button:hover {
	background-color: #0056b3;
	color: white;
}

/* 모달 배경 스타일 */
#modal-background {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 999;
}

/* 모달 창 스타일 */
#modal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: white;
	width: 400px;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	text-align: center;
}

/* 모달의 content div 스타일 */
#modal-content {
	margin-bottom: 20px;
}

#modal-content h2 {
	margin-bottom: 10px;
}

#modal-content p {
	margin-bottom: 20px;
}

#modal button {
	background-color: #007bff;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}

#modal button:hover {
	background-color: #0056b3;
}

#add-modal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 90%;
	max-width: 500px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	text-align: center;
}

#add-modal h2 {
	font-size: 24px;
	color: #333;
	margin-bottom: 20px;
	font-weight: bold;
}

#add-modal form {
	display: flex;
	flex-direction: column;
	align-items: center;
}

#add-modal form label {
	width: 100%;
	margin-bottom: 10px;
	font-size: 16px;
	text-align: left;
}

#add-modal form label {
    width: 100%;
    margin-bottom: 20px;  /* 아래쪽 여백을 20px로 설정 */
    font-size: 16px;
    text-align: left;
}

#add-modal form select {
    width: 100%;
    padding: 12px;
    font-size: 16px;
    margin: 8px 0;
    border-radius: 6px;
    border: 1px solid #ddd;
    box-sizing: border-box;
    transition: border-color 0.3s ease;
}

#add-modal form select:focus {
    border-color: #007bff;
    outline: none;
}

#add-modal form input[type="text"], #add-modal form input[type="date"],
	#add-modal form input[type="url"] {
	width: 100%;
	padding: 12px;
	font-size: 16px;
	margin: 8px 0;
	border-radius: 6px;
	border: 1px solid #ddd;
	box-sizing: border-box;
	transition: border-color 0.3s ease;
}

#add-modal form input[type="text"]:focus, #add-modal form input[type="date"]:focus,
	#add-modal form input[type="url"]:focus {
	border-color: #007bff;
	outline: none;
}

#add-modal form button[type="submit"], #add-modal form button[type="button"]
	{
	background-color: #007bff;
	color: white;
	border: none;
	padding: 12px 100px;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	margin-top: 20px;
}

#add-modal form button[type="submit"]:hover, #add-modal form button[type="button"]:hover
	{
	background-color: #0056b3;
}

#add-modal form button[type="button"] {
	background-color: #f44336;
	margin-top: 10px;
}

#add-modal form button[type="button"]:hover {
	background-color: #d32f2f;
}

/* 공모전 수정 모달 스타일 */
#edit-modal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 80%;
	max-width: 500px;
	background-color: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	text-align: center;
}

#edit-modal h2 {
	font-size: 24px;
	color: #333;
	margin-bottom: 20px;
	font-weight: bold;
}

#edit-modal form {
	display: flex;
	flex-direction: column;
	align-items: center;
}

#edit-modal form label {
	width: 100%;
	margin-bottom: 10px;
	font-size: 16px;
	text-align: left;
}

#edit-modal form input[type="text"], #edit-modal form input[type="date"],
	#edit-modal form input[type="url"] {
	width: 100%;
	padding: 12px;
	font-size: 16px;
	margin: 8px 0;
	border-radius: 6px;
	border: 1px solid #ddd;
	box-sizing: border-box;
	transition: border-color 0.3s ease;
}

#edit-modal form input[type="text"]:focus, #edit-modal form input[type="date"]:focus,
	#edit-modal form input[type="url"]:focus {
	border-color: #007bff;
	outline: none;
}

#edit-modal form button[type="submit"], #edit-modal form button[type="button"]
	{
	background-color: #007bff;
	color: white;
	border: none;
	padding: 12px 100px;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	margin-top: 20px;
}

#edit-modal form button[type="submit"]:hover, #edit-modal form button[type="button"]:hover
	{
	background-color: #0056b3;
}

#edit-modal form button[type="button"] {
	background-color: #f44336;
	margin-top: 10px;
}

#edit-modal form button[type="button"]:hover {
	background-color: #d32f2f;
}

/* 공모전 삭제 모달 스타일 */
#delete-modal {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 90%;
	max-width: 500px;
	background-color: #ffffff;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	z-index: 1000;
	text-align: center;
}

#delete-modal h2 {
	font-size: 24px;
	color: #333;
	margin-bottom: 20px;
	font-weight: bold;
}

#delete-modal p {
	font-size: 16px;
	color: #555;
	margin-bottom: 30px;
}

#delete-modal span {
	color: #f44336;
	font-weight: bold;
}

#delete-modal .modal-buttons {
	display: flex;
	justify-content: center;
	gap: 20px;
}

#delete-modal .modal-buttons button {
	padding: 12px 24px;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	border: none;
	transition: background-color 0.3s ease;
}

#delete-modal .modal-buttons .delete-button {
	background-color: #f44336;
	color: white;
}

#delete-modal .modal-buttons .delete-button:hover {
	background-color: #d32f2f;
}

#delete-modal .modal-buttons .cancel-button {
	background-color: #2196f3;
	color: white;
}

#delete-modal .modal-buttons .cancel-button:hover {
	background-color: #1976d2;
}

/* 팝업 메시지 스타일 */
#popup-message {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 300px;
	background-color: white;
	box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
	border-radius: 10px;
	z-index: 2000;
	padding: 20px;
	text-align: center;
}

#popup-message h2 {
	font-size: 18px;
	margin-bottom: 10px;
}

#popup-message p {
	margin-bottom: 20px;
}

#popup-message button {
	background-color: #007bff;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}

#popup-message button:hover {
	background-color: #0056b3;
}

/* 배경 어둡게 처리 */
#popup-background {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 1999;
}

#site-name {
	color: white;
	text-decoration: none;
	font-size: 24px;
}

#site-name:hover {
	color: #e0e0e0; /* 사이트 이름을 클릭할 때 색상 변화 */
}

#auth-section {
	display: flex;
	align-items: center;
}

#auth-section button {
	background-color: white;
	border: none;
	padding: 10px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 18px;
	color: #007bff;
	margin-left: 10px;
}

#auth-section button:hover {
	background-color: #0056b3;
	color: white;
}

.layout {
	display: flex;
	flex: 1;
}

.sidebar-container {
	width: 250px;
	background-color: #343a40;
	color: white;
	padding: 20px;
	display: flex;
	flex-direction: column;
	height: 100%;
}

.sidebar-container.hidden {
	width: 0;
	padding: 0;
	overflow: hidden;
}

nav ul {
	list-style: none;
	padding-left: 0;
}

nav ul li {
	margin-bottom: 15px;
}

nav ul li a {
	color: white;
	text-decoration: none;
	font-size: 18px;
	display: block;
}

nav ul li a:hover {
	color: #007bff;
}

.submenu {
	margin-left: 20px;
	display: none;
}

.submenu.active {
	display: block;
}

main {
	flex: 1;
	padding: 20px;
	position: relative;
	overflow-y: auto; /* 메인 콘텐츠에서 스크롤이 가능하게 설정 */
}

.page-card {
	display: none;
	width: 100%;
	min-height: 100%; /* 페이지 카드의 높이를 부모 요소에 맞추어 설정 */
	padding: 20px;
	background-color: white;
	overflow-y: auto; /* 페이지 카드 내에서 스크롤 가능 */
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.page-card-home {
	display: none;
	width: 100%;
	min-height: 100%; /* 페이지 카드의 높이를 부모 요소에 맞추어 설정 */
	/* padding: 20px; */
	background-color: white;
	overflow-y: auto; /* 페이지 카드 내에서 스크롤 가능 */
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.page-card.active {
	display: block;
}

footer {
	background-color: #2a9df4;
	color: white;
	text-align: center;
	padding: 10px;
	margin-top: auto;
	width: 100%;
}

@media ( max-width : 768px) {
	.sidebar-container {
		position: relative;
		width: 100%;
		height: auto;
		padding: 20px;
		overflow: hidden;
		transition: height 0.3s ease;
		z-index: 1000;
	}
	.sidebar-container.hidden {
		display: none;
	}
	.layout {
		flex-direction: column;
	}
	main {
		padding: 20px;
	}
}

.container {
	max-width: 1200px;
	margin: 20px auto;
	padding: 20px;
	background-color: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	border-radius: 8px;
}

.filter-buttons {
	text-align: center;
	margin: 20px auto;
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	max-width: 1050px;
}

.filter-buttons button {
	width: 120px;
	height: 40px;
	margin: 5px;
	border: none;
	background-color: #2a9df4;
	color: white;
	font-size: 14px;
	border-radius: 5px;
	cursor: pointer;
	text-align: center;
	line-height: 40px;
}

.filter-buttons input[type="text"] {
	width: 660px; /* 원하는 크기 설정 */
	padding: 10px;
	font-size: 16px;
	margin-right: 10px; /* 버튼과의 간격 */
	border: 1px solid #ddd;
	border-radius: 5px;
}

.filter-buttons button:hover {
	background-color: #2179b8;
}

.filter-buttons:nth-child(1) {
	margin-bottom: 30px;
}

.contest-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
}

.contest-item {
	background-color: #fff;
	border: 1px solid #ddd;
	border-radius: 8px;
	overflow: hidden;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	transition: transform 0.3s, box-shadow 0.3s;
}

.contest-item:hover {
	transform: translateY(-10px);
	box-shadow: 0 10px 15px rgba(0, 0, 0, 0.2);
}

.contest-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.contest-details {
	flex: 1;
	padding: 15px;
	display: flex;
	flex-direction: column;
	justify-content: space-between;
}

.contest-title {
	font-size: 18px;
	margin-bottom: 10px;
	color: #333;
}

.contest-title:hover {
	text-decoration: underline;
}

.contest-organizer, .contest-dates {
	font-size: 14px;
	color: #666;
	margin-bottom: 8px;
}

.contest-link {
	margin-top: auto;
	padding: 10px 15px;
	background-color: #2a9df4;
	color: white;
	text-decoration: none;
	border-radius: 5px;
	font-size: 14px;
	text-align: center;
}

.contest-link:hover {
	background-color: #2179b8;
}

.contest-buttons {
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
}

.contest-add {
	background-color: #fff;
	border-radius: 10px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	width: 400px;
	padding: 30px;
	box-sizing: border-box;
	text-align: center;
}

.contest-delete-button {
	background-color: #FF4500;
	color: white;
	border: none;
	padding: 10px 47px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 14px;
}

.contest-edit-button {
	background-color: #FFB347;
	color: white;
	border: none;
	padding: 10px 47px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 14px;
}

.contest-edit-button:hover, .contest-delete-button:hover {
	background-color: #2179b8;
}

.pagination {
	text-align: center;
	margin-top: 20px;
}

.pagination a, .pagination span {
	display: inline-block;
	margin: 0 5px;
	padding: 10px 15px;
	color: #2a9df4;
	text-decoration: none;
	border: 1px solid #2a9df4;
	border-radius: 5px;
}

.pagination a:hover {
	background-color: #2a9df4;
	color: white;
}

.pagination .active {
	background-color: #2a9df4;
	color: white;
	border: none;
}

#add-modal, #edit-modal, #delete-modal {
	display: none; /* 기본적으로 숨기기 */
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 80%;
	max-width: 500px;
	background-color: white;
	padding: 20px;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
	z-index: 1000;
}

@media ( max-width : 1200px) {
	.contest-grid {
		grid-template-columns: repeat(3, 1fr);
	}
}

@media ( max-width : 900px) {
	.contest-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	header {
		font-size: 20px;
	}
}

@media ( max-width : 600px) {
	.contest-grid {
		grid-template-columns: 1fr;
	}
}
</style>

<script>
    
    	//login
    	// 로그인 상태 체크를 위한 변수
	    let isLoggedIn = false;
	
	    // 로그인 폼을 표시하는 함수
	    function showLogin() {
	    	window.location.href = context + '/login';
	    }
	
	    // 로그아웃 처리 함수
	    function logout() {
	    	// 로그아웃 폼을 생성하고 제출하는 함수
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'logout';  // 로그아웃을 처리하는 서버의 URL

            document.body.appendChild(form);  // 폼을 동적으로 문서에 추가
            form.submit();  // 폼 제출
	    }
	
	    // 페이지 로드 시 로그인 상태 초기화
	    /* document.addEventListener('DOMContentLoaded', function () {
	        if (isLoggedIn) {
	            document.getElementById("login-button").style.display = "none";
	            document.getElementById("user-info").style.display = "block";
	        } else {
	        	document.getElementById("login-button").style.display = "block";
	            document.getElementById("user-info").style.display = "none";
	        }
	    }); */

	    function getExtension(url) {
	   		const regex = /\.([0-9a-z]+)(?:[\?#]|$)/i;
	    	const extension = url.match(regex);
	    	if (extension) {
	    	    return extension[1].toLowerCase();
	    	}

	    	return '';
	    }
		
	 	// 페이지를 로드하고 카드를 동적으로 생성하는 함수
	    async function loadPage(pageId, pageUrl, reload = false ) {
	        const mainContent = document.querySelector('main');
	        const existingPage = document.getElementById(pageId);

	        // 이미 로드된 페이지가 있으면 reload 조건에 따라 처리
	        if (existingPage) {
	            if (reload) {
	                existingPage.remove();
	            } else {
	                setActivePage(pageId);
	                return;
	            }
	        }

	        // POST 요청을 보내면서 파라미터를 전달
	        const response = await fetch(pageUrl, {
	            method: getExtension(pageUrl) == 'html' ? 'GET':'POST'
	        });
	        
	        const isOk = response.ok;
	        const data = await response.text();

	        if (!isOk) {
	            openModalFetch(data);  // 오류 발생 시 모달 창 호출
	        } else {
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
		            console.log()
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
	        }
	    }

        
     	// padding을 home 페이지일 때만 0으로 설정하는 함수
        function adjustPaddingForHome(pageId) {
            const pageElement = document.getElementById(pageId);
            
            if (pageId === 'home') {
                pageElement.style.padding = '0px';  // home 페이지의 padding을 0으로 설정
            } else {
                pageElement.style.padding = '20px';  // 다른 페이지의 padding을 기본값으로 설정
            }
        }

        // 특정 페이지를 활성화하는 함수
        function setActivePage(pageId) {
            const pages = document.querySelectorAll('.page-card');
            pages.forEach(page => {
                page.classList.remove('active');
            });

            const targetPage = document.getElementById(pageId);
            if (targetPage) {
                targetPage.classList.add('active');
                localStorage.setItem('currentPage', pageId); // 현재 페이지 상태 저장
            }
        }

        // 서브메뉴 토글 함수
        function toggleSubmenu() {
            const submenu = document.getElementById('submenu');
            submenu.classList.toggle('active');
        }

        // 메뉴 접기/펼치기 버튼 동작
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar-container');
            sidebar.classList.toggle('hidden');
            sidebar.classList.toggle('active');
        }

        document.addEventListener('DOMContentLoaded', function () {
           loadPage('home', 'html/home.html'); // 기본 페이지를 로드
        });
        
    	// 팝업 메시지 표시
        function showPopupMessage() {
            document.getElementById('popup-message').style.display = 'block';
            document.getElementById('popup-background').style.display = 'block';
        }

        // 팝업 메시지 숨기기
        function hidePopupMessage() {
            document.getElementById('popup-message').style.display = 'none';
            document.getElementById('popup-background').style.display = 'none';
        }
        
     	// local에서 모달 창 열기
        function openModal(message) {
            document.getElementById('modal-message').innerText = message;
            document.getElementById('modal').style.display = 'block';
            document.getElementById('modal-background').style.display = 'block';
        }
     	
        // 모달 창 닫기
        function closeModal() {
            document.getElementById('modal').style.display = 'none';
            document.getElementById('modal-background').style.display = 'none';
        }
        
     	// 모달 창 닫기
        function openModalFetch(html) {
            document.getElementById('modal').style.display = 'block';
            document.getElementById('modal-content').innerHTML= html;
            document.getElementById('modal-background').style.display = 'block';
        }
     	

     	// 모달 밖 클릭 시 닫기
       /*  window.onclick = function(event) {
            if (event.target == document.getElementById('modal-background')) {
                closeModal();
            }
        } */
        
     

     // 공모전 추가 모달 열기
        function showAddModal() {
            document.getElementById('add-modal').style.display = 'block';
            document.getElementById('modal-background').style.display = 'block';
        }

        function validateEditForm() {
            const title = document.getElementById('edit-title').value;
            const organizer = document.getElementById('edit-organizer').value;
            const startDay = document.getElementById('edit-start_day').value;
            const finishDay = document.getElementById('edit-finish_day').value;
            const homepage = document.getElementById('edit-homepage').value;

            // 디버깅: 값 확인
            console.log('Title:', title);
            console.log('Organizer:', organizer);
            console.log('Start Date:', startDay);
            console.log('Finish Date:', finishDay);
            console.log('Homepage:', homepage);

            if (!title || !organizer || !startDay || !finishDay || !homepage) {
                alert("모든 필드를 입력하세요.");
                return false;
            }
            return true;
        }

        function showEditModal(title, organizer, startDay, finishDay, homepage, img, num) {
            document.getElementById('edit-title').value = decodeURIComponent(title);
            document.getElementById('edit-organizer').value = decodeURIComponent(organizer);
            document.getElementById('edit-start_day').value = decodeURIComponent(startDay);
            document.getElementById('edit-finish_day').value = decodeURIComponent(finishDay);
            document.getElementById('edit-homepage').value = decodeURIComponent(homepage);
            document.getElementById('edit-img').value = decodeURIComponent(img);
            document.getElementById('edit-num').value = num;  // 여기가 중요합니다.
            
            document.getElementById('edit-modal').style.display = 'block';
            document.getElementById('modal-background').style.display = 'block';
        }
     
        function validateEditForm() {
            const title = document.getElementById('edit-title').value;
            const organizer = document.getElementById('edit-organizer').value;
            const startDay = document.getElementById('edit-start_day').value;
            const finishDay = document.getElementById('edit-finish_day').value;
            const homepage = document.getElementById('edit-homepage').value;

            console.log('Title:', title);
            console.log('Organizer:', organizer);
            console.log('Start Date:', startDay);
            console.log('Finish Date:', finishDay);
            console.log('Homepage:', homepage);

            if (!title || !organizer || !startDay || !finishDay || !homepage) {
                alert("모든 필드를 입력하세요.");
                return false;
            }
            return true;
        }
     
        function submitEditForm() {
            const num = document.getElementById('edit-num').value;
            const title = document.getElementById('edit-title').value;
            const organizer = document.getElementById('edit-organizer').value;
            const startDay = document.getElementById('edit-start_day').value;
            const finishDay = document.getElementById('edit-finish_day').value;
            const homepage = document.getElementById('edit-homepage').value;

            console.log('Submitting form with the following data:');
            console.log('Num:', num);
            console.log('Title:', title);
            console.log('Organizer:', organizer);
            console.log('Start Day:', startDay);
            console.log('Finish Day:', finishDay);
            console.log('Homepage:', homepage);

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'index.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    console.log(xhr.responseText); // 서버 응답을 콘솔에 출력
                    window.location.reload(); // 페이지 새로 고침
                }
            };

            xhr.send('action=edit&num=' + encodeURIComponent(num) + 
                     '&title=' + encodeURIComponent(title) +
                     '&organizer=' + encodeURIComponent(organizer) +
                     '&start_day=' + encodeURIComponent(startDay) +
                     '&finish_day=' + encodeURIComponent(finishDay) +
                     '&homepage=' + encodeURIComponent(homepage));
        }

     // 공모전 삭제 모달 열기
        function showDeleteModal(title) {
            // 삭제 모달에 공모전 제목 설정
            document.getElementById('delete-title').innerText = title;

            // 모달 띄우기
            document.getElementById('delete-modal').style.display = 'block';
            document.getElementById('modal-background').style.display = 'block';

            // 삭제할 공모전 제목 저장
            document.getElementById('delete-contest-title').value = title;
        }

     	// 공모전 삭제 처리
        function deleteContest() {
		    var title = document.getElementById('delete-contest-title').value;
		
		    // AJAX를 사용하여 서버로 삭제 요청
		    var xhr = new XMLHttpRequest();
		    xhr.open("POST", "index.jsp", true);
		    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		
		    // 폼 데이터를 서버에 전송 (삭제할 제목 포함)
		    var params = "action=delete&contestTitle=" + encodeURIComponent(title);
		
		    // 서버에서 삭제 처리 후 성공하면 페이지 새로고침
		    xhr.onreadystatechange = function() {
		        if (xhr.readyState === 4 && xhr.status === 200) {
		            // 서버 응답 처리 후 페이지 새로 고침
		            window.location.reload();  // 삭제 후 페이지 새로 고침
		        }
		    };
		
		    // 서버로 요청 전송
		    xhr.send(params);
		}
     	
     	// 모달 닫기
        function closeModal() {
            document.getElementById('add-modal').style.display = 'none';
            document.getElementById('edit-modal').style.display = 'none';
            document.getElementById('delete-modal').style.display = 'none';
            document.getElementById('modal-background').style.display = 'none';
        }
     
     
        
    </script>
</head>
<body>
	<header>
		<button onclick="toggleSidebar()">☰</button>
		<a href="index.jsp" id="site-name">공모전 다모아</a>
		<!-- 사이트 이름을 클릭하면 홈으로 이동 -->
		<div id="auth-section">
			<!-- 로그인 또는 사용자 정보가 표시되는 영역 -->
			<c:if test="${empty sessionScope.user}">
				<button id="login-button" onclick="showLogin()">로그인</button>
			</c:if>
			<c:if test="${not empty sessionScope.user}">
				<div id="user-info"
					style="display: ${not empty sessionScope.user ? block : none} ;">
					<span id="username"
						title="${sessionScope.user.roles[0]} ${sessionScope.user.email}">${sessionScope.user.name}</span>
					<button id="logout-button" onclick="logout()">로그아웃</button>
				</div>
			</c:if>
		</div>
	</header>

	<div class="layout">
		<div class="sidebar-container hidden">
			<nav>
				<ul>
					<li><a href="index.jsp">홈</a></li>
					<%--  <c:if test="${not empty sessionScope.user }"> --%>
					<li><a href="#" onclick="toggleSubmenu()">사용자 관리</a></li>
					<ul id="submenu" class="submenu">
						<li><a href="#"
							onclick="loadPage('userList', 'user/userlist')">사용자 목록</a></li>
						<li><a href="#" onclick="loadPage('user', 'user/form', true)">사용자
								입력</a></li>
					</ul>
					<li><a href="#" onclick="loadPage('service', 'service.html')">서비스</a></li>
					<li><a href="#" onclick="loadPage('contact', 'contact.html')">연락처</a></li>
					<%--   </c:if> --%>
				</ul>
			</nav>
		</div>

		<main>
			<!-- 페이지 카드들이 동적으로 여기에 생성됩니다 -->
		</main>
	</div>





	<div class="filter-buttons">
		<form method="get" action="index.jsp">
			<button type="submit" name="category" value="전체">전체</button>
			<button type="submit" name="category" value="기획/아이디어">기획/아이디어</button>
			<button type="submit" name="category" value="광고/마케팅">광고/마케팅</button>
			<button type="submit" name="category" value="논문/리포트">논문/리포트</button>
			<button type="submit" name="category" value="영상/UCC/사진">영상/UCC/사진</button>
			<button type="submit" name="category" value="디자인/캐릭터/웹툰">디자인/캐릭터/웹툰</button>
			<button type="submit" name="category" value="웹/모바일/IT">웹/모바일/IT</button>
			<button type="submit" name="category" value="게임/소프트웨어">게임/소프트웨어</button>
			<button type="submit" name="category" value="문학/글/시나리오">문학/글/시나리오</button>
			<button type="submit" name="category" value="과학/공학">과학/공학</button>
			<button type="submit" name="category" value="건축/인테리어">건축/인테리어</button>
			<button type="submit" name="category" value="봉사활동">봉사활동</button>
			<button type="submit" name="category" value="취업/창업">취업/창업</button>
			<button type="submit" name="category" value="기타">기타</button>
		</form>



		<!-- 검색 기능 추가 -->
		<form method="get" action="index.jsp">
			<input type="text" name="search" placeholder="공모전 제목을 입력하세요"
				value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
			<button type="submit">검색</button>
		</form>
		<button onclick="showAddModal()">공모전 추가</button>
	</div>

	<!-- 공모전 추가 모달 -->
	<div id="add-modal" style="display: none;">
		<h2>공모전 추가</h2>
		<form method="POST" action="index.jsp"
			onsubmit="return validateAddForm()">
			<input type="hidden" name="action" value="add"> <label>제목:
				<input type="text" id="title" name="title" required>
			</label><br> <label>주최: <input type="text" id="organizer"
				name="organizer" required>
			</label><br> <label>카테고리: <select id="field" name="field"
				required>
					<option value="기획/아이디어">기획/아이디어</option>
					<option value="광고/마케팅">광고/마케팅</option>
					<option value="논문/리포트">논문/리포트</option>
					<option value="영상/UCC/사진">영상/UCC/사진</option>
					<option value="디자인/캐릭터/웹툰">디자인/캐릭터/웹툰</option>
					<option value="웹/모바일/IT">웹/모바일/IT</option>
					<option value="게임/소프트웨어">게임/소프트웨어</option>
					<option value="문학/글/시나리오">문학/글/시나리오</option>
					<option value="과학/공학">과학/공학</option>
					<option value="건축/인테리어">건축/인테리어</option>
					<option value="봉사활동">봉사활동</option>
					<option value="취업/창업">취업/창업</option>
					<option value="기타">기타</option>
			</select>
			</label><br> <label>시작일: <input type="date" id="start_day"
				name="start_day" required>
			</label><br> <label>종료일: <input type="date" id="finish_day"
				name="finish_day" required>
			</label><br> <label>홈페이지: <input type="url" id="homepage"
				name="homepage" required>
			</label><br> <label>이미지 URL: <input type="url" id="img"
				name="img" required>
			</label><br>
			<button type="submit">추가</button>
			<button type="button" onclick="closeModal()">닫기</button>
		</form>
	</div>


	<!-- 공모전 수정 모달 -->
	<div id="edit-modal" style="display: none;">
		<h2>공모전 수정</h2>
		<form method="POST" action="index.jsp"
			onsubmit="return validateEditForm()">
			<input type="hidden" name="action" value="edit"> <input
				type="hidden" id="edit-num" name="num"> <label>제목: <input
				type="text" id="edit-title" name="title" required>
			</label><br> <label>주최: <input type="text" id="edit-organizer"
				name="organizer" required>
			</label><br> <label>시작일: <input type="date" id="edit-start_day"
				name="start_day" required>
			</label><br> <label>종료일: <input type="date" id="edit-finish_day"
				name="finish_day" required>
			</label><br> <label>홈페이지: <input type="url" id="edit-homepage"
				name="homepage" required>
			</label><br> <label>이미지 URL: <input type="url" id="edit-img"
				name="img" required>
			</label><br>

			<button type="submit">수정</button>
			<button type="button" onclick="closeModal()">닫기</button>
		</form>
	</div>


	<!-- 공모전 삭제 모달 -->
	<div id="delete-modal" style="display: none;">
		<h2>공모전 삭제</h2>
		<p>
			정말로 <span id="delete-title"></span> 공모전을 삭제하시겠습니까?
		</p>
		<div class="modal-buttons">
			<input type="hidden" id="delete-contest-title" />
			<button class="delete-button" onclick="deleteContest()">삭제</button>
			<button class="cancel-button" type="button" onclick="closeModal()">취소</button>
		</div>
	</div>

	<div class="container">
		<div class="contest-grid">
			<%
			int contestsPerPage = 16;
			int currentPage = 1;
			int totalPages = 0;
			if (request.getParameter("page") != null) {
				currentPage = Integer.parseInt(request.getParameter("page"));
			}
			int offset = (currentPage - 1) * contestsPerPage;

			String category = request.getParameter("category");
			if (category == null || category.equals("전체")) {
				category = "전체";
			}

			String searchKeyword = request.getParameter("search");

			java.util.Map<String, String[]> categoryKeywords = new java.util.HashMap<>();
			categoryKeywords.put("기획/아이디어", new String[] { "기획", "아이디어" });
			categoryKeywords.put("광고/마케팅", new String[] { "광고", "마케팅" });
			categoryKeywords.put("논문/리포트", new String[] { "논문", "리포트" });
			categoryKeywords.put("영상/UCC/사진", new String[] { "영상", "UCC", "사진" });
			categoryKeywords.put("디자인/캐릭터/웹툰", new String[] { "디자인", "캐릭터", "웹툰" });
			categoryKeywords.put("웹/모바일/IT", new String[] { "웹", "모바일", "IT" });
			categoryKeywords.put("게임/소프트웨어", new String[] { "게임", "소프트웨어" });
			categoryKeywords.put("문학/글/시나리오", new String[] { "문학", "글", "시나리오" });
			categoryKeywords.put("과학/공학", new String[] { "과학", "공학" });
			categoryKeywords.put("건축/인테리어", new String[] { "건축", "인테리어" });
			categoryKeywords.put("봉사활동", new String[] { "봉사" });
			categoryKeywords.put("취업/창업", new String[] { "취업", "창업" });
			categoryKeywords.put("기타", new String[] { "기타" });

			String dbUrl = "jdbc:mysql://localhost:3306/cswp_202221889_db";
			String dbUser = "cswp_202221889_fe";
			String dbPassword = "202221889";

			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl, dbUser, dbPassword);
				java.sql.Statement stmt = conn.createStatement();

				// 카테고리 필터링과 검색어를 반영한 쿼리
				String countQuery = "SELECT COUNT(*) AS total FROM contests WHERE 1=1";
				if (!category.equals("전체")) {
					String[] keywords = categoryKeywords.get(category);
					StringBuilder condition = new StringBuilder();
					for (int i = 0; i < keywords.length; i++) {
				condition.append("field LIKE '%").append(keywords[i]).append("%'");
				if (i < keywords.length - 1) {
					condition.append(" OR ");
				}
					}
					countQuery += " AND (" + condition.toString() + ")";
				}

				if (searchKeyword != null && !searchKeyword.isEmpty()) {
					countQuery += " AND title LIKE '%" + searchKeyword + "%'";
				}

				java.sql.ResultSet countRs = stmt.executeQuery(countQuery);
				if (countRs.next()) {
					int totalContests = countRs.getInt("total");
					totalPages = (int) Math.ceil((double) totalContests / contestsPerPage);
				}

				String query = "SELECT * FROM contests WHERE 1=1";
				if (!category.equals("전체")) {
					String[] keywords = categoryKeywords.get(category);
					StringBuilder condition = new StringBuilder();
					for (int i = 0; i < keywords.length; i++) {
				condition.append("field LIKE '%").append(keywords[i]).append("%'");
				if (i < keywords.length - 1) {
					condition.append(" OR ");
				}
					}
					query += " AND (" + condition.toString() + ")";
				}

				if (searchKeyword != null && !searchKeyword.isEmpty()) {
					query += " AND title LIKE '%" + searchKeyword + "%'";
				}

				query += " LIMIT " + contestsPerPage + " OFFSET " + offset;

				java.sql.ResultSet rs = stmt.executeQuery(query);

				while (rs.next()) {
					String num = rs.getString("num");
					String img = rs.getString("img");
					String title = rs.getString("title");
					String organizer = rs.getString("organizer");
					String field = rs.getString("field");
					String startDay = rs.getString("start_day");
					String finishDay = rs.getString("finish_day");
					String homepage = rs.getString("homepage");
			%>
			<div class="contest-item">
				<img src="<%=img%>" alt="공모전 이미지">
				<div class="contest-details">
					<a href="<%=homepage%>" target="_blank" class="contest-title"><%=title%></a>
					<p class="contest-organizer">
						주최:
						<%=organizer%>
					</p>
					<p class="contest-organizer">
						분야:
						<%=field%>
					</p>
					<p class="contest-dates">
						기간:
						<%=startDay%>
						~
						<%=finishDay%>
					</p>

					<!-- 수정, 삭제 버튼 추가 -->
					<div class="contest-buttons">
						<button class="contest-edit-button"
							onclick="showEditModal('<%=URLEncoder.encode(title, "UTF-8")%>', 
                           '<%=URLEncoder.encode(organizer, "UTF-8")%>', 
                           '<%=URLEncoder.encode(startDay, "UTF-8")%>', 
                           '<%=URLEncoder.encode(finishDay, "UTF-8")%>', 
                           '<%=URLEncoder.encode(homepage, "UTF-8")%>', 
                           '<%=URLEncoder.encode(img, "UTF-8")%>', 
                           '<%=num%>')">수정</button>
						<button class="contest-delete-button"
							onclick="showDeleteModal('<%=title%>')">삭제</button>
					</div>

					<a href="<%=homepage%>" target="_blank" class="contest-link">자세히
						보기</a>
				</div>
			</div>
			<%
			}
			conn.close();
			} catch (Exception e) {
			out.println("<p>데이터를 불러오는 중 오류가 발생했습니다: " + e.getMessage() + "</p>");
			}
			%>
		</div>

		<div class="pagination">
			<%
			int pageRange = 5;
			int groupStart = ((currentPage - 1) / pageRange) * pageRange + 1;
			int groupEnd = Math.min(groupStart + pageRange - 1, totalPages);

			if (groupStart > 1) {
			%>
			<a href="?page=<%=groupStart - 1%>&category=<%=category%>">&laquo;
				이전</a>
			<%
			}

			for (int i = groupStart; i <= groupEnd; i++) {
			if (i == currentPage) {
			%>
			<span class="active"><%=i%></span>
			<%
			} else {
			%>
			<a href="?page=<%=i%>&category=<%=category%>"><%=i%></a>
			<%
			}
			}

			if (groupEnd < totalPages) {
			%>
			<a href="?page=<%=groupEnd + 1%>&category=<%=category%>">다음
				&raquo;</a>
			<%
			}
			%>
		</div>
	</div>

	<footer> © 2024 내 웹사이트 - 모든 권리 보유 </footer>

	<%
	String action = request.getParameter("action");

	if ("add".equals(action)) {
	    // 공모전 추가 처리
	    String title = request.getParameter("title");
	    String organizer = request.getParameter("organizer");
	    String[] fields = request.getParameterValues("field");  // 여러 카테고리를 받음
	    String startDay = request.getParameter("start_day");
	    String finishDay = request.getParameter("finish_day");
	    String homepage = request.getParameter("homepage");
	    String img = request.getParameter("img");

	    // 각 선택된 카테고리를 하나의 문자열로 합침
	    String field = String.join(", ", fields);  // 카테고리들 간에 쉼표로 구분하여 저장

	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
	        String insertQuery = "INSERT INTO contests (title, organizer, field, start_day, finish_day, homepage, img) VALUES (?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement ps = conn.prepareStatement(insertQuery);
	        ps.setString(1, title);
	        ps.setString(2, organizer);
	        ps.setString(3, field);  // 여러 카테고리 값 저장
	        ps.setString(4, startDay);
	        ps.setString(5, finishDay);
	        ps.setString(6, homepage);
	        ps.setString(7, img); // 이미지 URL을 데이터베이스에 저장

	        int rowsAffected = ps.executeUpdate();
	        if (rowsAffected > 0) {
	            out.println("<p>공모전이 추가되었습니다.</p>");
	        } else {
	            out.println("<p>공모전 추가 실패.</p>");
	        }
	        conn.close();
	    } catch (Exception e) {
	        out.println("<p>오류 발생: " + e.getMessage() + "</p>");
	    }
	}

	if ("edit".equals(action)) {
		String num = request.getParameter("num"); // 수정할 공모전의 num을 받습니다.
		String title = request.getParameter("title");
		String organizer = request.getParameter("organizer");
		String startDay = request.getParameter("start_day");
		String finishDay = request.getParameter("finish_day");
		String homepage = request.getParameter("homepage");
		String img = request.getParameter("img");

		try {
			// 디코딩
			title = URLDecoder.decode(title, "UTF-8");
			organizer = URLDecoder.decode(organizer, "UTF-8");
			startDay = URLDecoder.decode(startDay, "UTF-8");
			finishDay = URLDecoder.decode(finishDay, "UTF-8");
			homepage = URLDecoder.decode(homepage, "UTF-8");

			// 로그 추가
			System.out.println("Updating contest with the following data:");
			System.out.println("Num: " + num);
			System.out.println("Title: " + title);
			System.out.println("Organizer: " + organizer);
			System.out.println("Start Day: " + startDay);
			System.out.println("Finish Day: " + finishDay);
			System.out.println("Homepage: " + homepage);

			// 데이터베이스 연결
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
			String updateQuery = "UPDATE contests SET title = ?, organizer = ?, start_day = ?, finish_day = ?, homepage = ?, img = ? WHERE num = ?";
			PreparedStatement ps = conn.prepareStatement(updateQuery);
			ps.setString(1, title);
			ps.setString(2, organizer);
			ps.setString(3, startDay);
			ps.setString(4, finishDay);
			ps.setString(5, homepage);
			ps.setString(6, img);
			ps.setString(7, num); // num을 기준으로 업데이트

			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
		out.println("<p>공모전 '" + title + "'이 수정되었습니다.</p>");
			} else {
		out.println("<p>공모전 수정 실패. 해당 num의 공모전이 존재하지 않습니다.</p>");
			}
			conn.close();
		} catch (Exception e) {
			out.println("<p>오류 발생: " + e.getMessage() + "</p>");
		}
	}

	// 공모전 삭제 처리
	if ("delete".equals(action)) {
		String contestTitle = request.getParameter("contestTitle");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

			// 공모전 삭제 쿼리
			String deleteQuery = "DELETE FROM contests WHERE title = ?";
			PreparedStatement ps = conn.prepareStatement(deleteQuery);
			ps.setString(1, contestTitle);

			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
		out.println("<p>공모전 '" + contestTitle + "'이 삭제되었습니다.</p>");
			} else {
		out.println("<p>공모전 삭제 실패. 해당 제목의 공모전이 존재하지 않습니다.</p>");
			}
			conn.close();
		} catch (Exception e) {
			out.println("<p>오류 발생: " + e.getMessage() + "</p>");
		}
	}
	%>

	<!-- 팝업 배경 -->
	<div id="popup-background" onclick="hidePopupMessage()"></div>

	<!-- 팝업 메시지 창 -->
	<div id="popup-message">
		<h2>알림</h2>
		<p>이것은 팝업 메시지입니다.</p>
		<button onclick="hidePopupMessage()">닫기</button>
	</div>

	<!-- 모달 배경 -->
	<div id="modal-background"></div>

	<!-- 모달 창 -->
	<div id="modal">
		<div id="modal-content">
			<h2 id="modal-title">알림</h2>
			<p id="modal-message">이것은 모달 팝업 메시지입니다.</p>
		</div>
		<button onclick="closeModal()">닫기</button>
	</div>

</body>
</html>