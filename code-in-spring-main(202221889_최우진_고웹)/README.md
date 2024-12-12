<h2>강의 예제 소스코드</h2>
<p>참고하세요</p>
<pre>
1. 내려 받기
	
소스코드를 받을 위치에서 예를 들어 /workspace 인 경우
cd /workspace
git clone https://github.com/kku-cs-wp/code-in-spring

2. eclipse project import 하기
Project Explorer 에서 오른쪽 마우스 클릭
1) import -> import 클릭
2) General -> Project from Folder or Archive 선택
3) import Project from File System or Archive 창에서 
	 - import source 에 소스폴더 위치 입력
		 /workspace/code-in-spring
	 - finish 클릭하여 완료

3. 프로젝트 Maven clean install
1) Database 연결정보 수정을 하거나 소스코드에 설정된 Database Schema 생성 하고 
	6주차 기초데이터 생성 스크립트를 이용하여 기초데이터 생성
2) maven clean install 실행
	Eclipse 에 import 된 프로젝트 오른쪽 클릭하여 하여 
		Run AS -> Maven Clean 실행
		Run AS -> Maven Install 실행
	mvn (Maven Console 프로그램 이 설치된 경우)
		프로젝트 폴더에서
		mvn clean install 실행
4. 프로젝트 실행 
	 Tomcat 서버 실행
</pre>
