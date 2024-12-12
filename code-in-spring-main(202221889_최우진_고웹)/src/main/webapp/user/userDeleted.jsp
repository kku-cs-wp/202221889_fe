<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="deletedcontainer">
        <h2>사용자 삭제 완료</h2>

        <h3>등록된 사용자 정보</h3>

        <div class="deleteduser-info">
            <div class="deletedinfo-item">
                <label>ID:</label>
                <span>${user.id}</span>
            </div>
            <div class="deletedinfo-item">
                <label>이름:</label>
                <span>${user.name}</span>
            </div>
        </div>

        <a href="#" class="deletedback-link" onclick="loadPage('userList', 'user/userlist', true)">사용자 목록 보기</a>
    </div>
     <style>
        /* 기본 스타일 */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        /* 컨테이너 스타일 */
        .deletedcontainer {
            max-width: 600px;
            margin: 50px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        /* 헤더 스타일 */
        h2 {
            text-align: center;
            color: #333;
        }

        h3 {
            color: #555;
            margin-bottom: 20px;
        }

        /* 사용자 정보 스타일 */
        .deleteduser-info {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .deletedinfo-item {
            display: flex;
            align-items: center;
        }

        .deletedinfo-item label {
            flex: 0 0 100px;
            font-weight: bold;
            color: #555;
        }

        .deletedinfo-item span {
            flex: 1;
            color: #333;
            background-color: #f9f9f9;
            padding: 8px 12px;
            border-radius: 4px;
        }

        /* 링크 스타일 */
        .deletedback-link {
            display: block;
            text-align: center;
            margin-top: 30px;
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
        }

        .deletedback-link:hover {
            text-decoration: underline;
        }
    </style>
