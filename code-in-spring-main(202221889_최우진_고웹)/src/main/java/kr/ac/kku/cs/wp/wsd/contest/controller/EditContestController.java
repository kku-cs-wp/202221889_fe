package kr.ac.kku.cs.wp.wsd.contest.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/editContest")
public class EditContestController extends HttpServlet {
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contestId = Integer.parseInt(request.getParameter("id"));
        // 데이터베이스에서 해당 공모전 정보를 가져와서 폼에 채워넣기
        // 예시 생략
    }

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int contestId = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String organizer = request.getParameter("organizer");
        String startDay = request.getParameter("startDay");
        String finishDay = request.getParameter("finishDay");

        // 파일 업로드 처리 및 업데이트
        Part filePart = request.getPart("img");
        String img = saveFile(filePart);

        // 데이터베이스에서 공모전 수정
        String dbUrl = "jdbc:mysql://localhost:3306/cswp_202221889_db";
        String dbUser = "cswp_202221889_fe";
        String dbPassword = "202221889";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String query = "UPDATE contests SET title=?, organizer=?, start_day=?, finish_day=?, img=? WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, title);
            stmt.setString(2, organizer);
            stmt.setString(3, startDay);
            stmt.setString(4, finishDay);
            stmt.setString(5, img);
            stmt.setInt(6, contestId);
            stmt.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("index.jsp");
    }

    private String saveFile(Part filePart) throws IOException {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String path = getServletContext().getRealPath("/uploads");
        File uploads = new File(path);
        if (!uploads.exists()) {
            uploads.mkdirs();
        }
        File file = new File(uploads, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath());
        }
        return "/uploads/" + fileName;
    }
}