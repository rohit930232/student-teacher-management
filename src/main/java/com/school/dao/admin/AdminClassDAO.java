package com.school.dao.admin;

import java.sql.*;
import java.util.*;
import com.school.util.DBConnection;

public class AdminClassDAO {

    private Connection getConn() {
        return DBConnection.getConnection();
    }

    public List<Map<String, String>> getClassListWithTeacher() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, "
                       + "COUNT(s.student_id) AS total, "
                       + "MAX(t.name) AS class_teacher "
                       + "FROM st_class c "
                       + "LEFT JOIN st_student s ON c.class_id = s.class_id "
                       + "LEFT JOIN st_teacher t ON c.class_id = t.class_id AND t.class_teacher IS NOT NULL "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",     rs.getString("class_id"));
                m.put("class_name",   rs.getString("class_name"));
                m.put("total",        rs.getString("total"));
                m.put("class_teacher",rs.getString("class_teacher"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getClassListWithExamCount() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, COUNT(e.exam_id) AS exam_count "
                       + "FROM st_class c LEFT JOIN st_exam e ON c.class_id = e.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",   rs.getString("class_id"));
                m.put("class_name", rs.getString("class_name"));
                m.put("exam_count", rs.getString("exam_count"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getClassListWithAssignmentCount() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, COUNT(a.assignment_id) AS assignment_count "
                       + "FROM st_class c LEFT JOIN st_assignment a ON c.class_id = a.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",          rs.getString("class_id"));
                m.put("class_name",        rs.getString("class_name"));
                m.put("assignment_count",  rs.getString("assignment_count"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getClassListWithTimetableCount() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, COUNT(tt.timetable_id) AS slot_count "
                       + "FROM st_class c LEFT JOIN st_timetable tt ON c.class_id = tt.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",   rs.getString("class_id"));
                m.put("class_name", rs.getString("class_name"));
                m.put("slot_count", rs.getString("slot_count"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getClassListWithOnlineStatus() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, "
                       + "SUM(CASE WHEN oc.status = 'Live' THEN 1 ELSE 0 END) AS live_count, "
                       + "SUM(CASE WHEN oc.status = 'Scheduled' THEN 1 ELSE 0 END) AS upcoming_count "
                       + "FROM st_class c LEFT JOIN st_online_class oc ON c.class_id = oc.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",       rs.getString("class_id"));
                m.put("class_name",     rs.getString("class_name"));
                m.put("upcoming_count", rs.getString("upcoming_count"));
                m.put("has_live",       rs.getInt("live_count") > 0 ? "true" : "false");
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getClassListWithStudentCount() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT c.class_id, c.class_name, COUNT(s.student_id) AS total "
                       + "FROM st_class c LEFT JOIN st_student s ON c.class_id = s.class_id "
                       + "GROUP BY c.class_id, c.class_name ORDER BY c.class_id";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("class_id",   rs.getString("class_id"));
                m.put("class_name", rs.getString("class_name"));
                m.put("total",      rs.getString("total"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getStudentsByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT student_id, name, username, email, mobile, gender, photo, roll_number FROM st_student WHERE class_id = ? ORDER BY roll_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("student_id",  rs.getString("student_id"));
                m.put("name",        rs.getString("name"));
                m.put("username",    rs.getString("username"));
                m.put("email",       rs.getString("email"));
                m.put("mobile",      rs.getString("mobile"));
                m.put("gender",      rs.getString("gender"));
                m.put("photo",       rs.getString("photo"));
                m.put("roll_number", rs.getString("roll_number"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public String getClassTeacherByClassId(int classId) {
        try {
            Connection con = getConn();
            String sql = "SELECT name FROM st_teacher WHERE class_id = ? AND class_teacher IS NOT NULL AND ROWNUM = 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("name");
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Map<String, String>> getExamsByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT e.*, t.name AS teacher_name FROM st_exam e LEFT JOIN st_teacher t ON e.teacher_id = t.teacher_id WHERE e.class_id = ? ORDER BY e.exam_date";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("exam_id",      rs.getString("exam_id"));
                m.put("subject",      rs.getString("subject"));
                m.put("exam_date",    rs.getString("exam_date"));
                m.put("start_time",   rs.getString("start_time"));
                m.put("end_time",     rs.getString("end_time"));
                m.put("total_marks",  rs.getString("total_marks"));
                m.put("teacher_name", rs.getString("teacher_name"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getResultsByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT r.*, s.name, s.roll_number, e.total_marks AS max_marks "
                       + "FROM st_result r "
                       + "JOIN st_student s ON r.student_id = s.student_id "
                       + "LEFT JOIN st_exam e ON r.exam_id = e.exam_id "
                       + "WHERE r.class_id = ? ORDER BY s.roll_number, r.subject";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("name",        rs.getString("name"));
                m.put("roll_number", rs.getString("roll_number"));
                m.put("subject",     rs.getString("subject"));
                m.put("marks",       rs.getString("marks"));
                m.put("max_marks",   rs.getString("max_marks"));
                m.put("grade",       rs.getString("grade"));
                m.put("exam_date",   rs.getString("exam_date"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getAssignmentsByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT a.*, t.name AS teacher_name, t.subject "
                       + "FROM st_assignment a LEFT JOIN st_teacher t ON a.teacher_id = t.teacher_id "
                       + "WHERE a.class_id = ? ORDER BY a.upload_date DESC";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("assignment_id", rs.getString("assignment_id"));
                m.put("title",         rs.getString("title"));
                m.put("description",   rs.getString("description"));
                m.put("upload_date",   rs.getString("upload_date"));
                m.put("deadline",      rs.getString("deadline"));
                m.put("file_path",     rs.getString("file_path"));
                m.put("teacher_name",  rs.getString("teacher_name"));
                m.put("subject",       rs.getString("subject"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Map<String, List<Map<String, String>>> getTimetableByClass(int classId) {
        Map<String, List<Map<String, String>>> map = new LinkedHashMap<>();
        try {
            Connection con = getConn();
            String sql = "SELECT tt.*, t.name AS teacher_name FROM st_timetable tt LEFT JOIN st_teacher t ON tt.teacher_id = t.teacher_id WHERE tt.class_id = ? ORDER BY tt.day, tt.start_time";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String day = rs.getString("day");
                Map<String, String> slot = new HashMap<>();
                slot.put("timetable_id",  rs.getString("timetable_id"));
                slot.put("subject",       rs.getString("subject"));
                slot.put("start_time",    rs.getString("start_time"));
                slot.put("end_time",      rs.getString("end_time"));
                slot.put("teacher_name",  rs.getString("teacher_name"));
                map.computeIfAbsent(day, k -> new ArrayList<>()).add(slot);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    public boolean addTimetableSlot(int classId, String day, String subject, Integer teacherId, String startTime, String endTime) {
        Connection con = null;
        try {
            con = getConn();
            if (con == null) {
                System.out.println("TIMETABLE ERROR: Connection is null");
                return false;
            }

            String sql = "INSERT INTO st_timetable (timetable_id, class_id, day, subject, teacher_id, start_time, end_time) "
                       + "VALUES (st_timetable_seq.NEXTVAL, ?, ?, ?, ?, ?, ?)";

            System.out.println("TIMETABLE INSERT: classId=" + classId + " day=" + day + " subject=" + subject
                    + " teacherId=" + teacherId + " start=" + startTime + " end=" + endTime);

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ps.setString(2, day);
            ps.setString(3, subject);
            if (teacherId != null && teacherId > 0) {
                ps.setInt(4, teacherId);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, startTime);
            ps.setString(6, endTime);

            int rows = ps.executeUpdate();
            System.out.println("TIMETABLE INSERT rows affected: " + rows);
            return rows > 0;

        } catch (Exception e) {
            System.out.println("TIMETABLE INSERT EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTimetableSlot(int timetableId) {
        try {
            Connection con = getConn();
            PreparedStatement ps = con.prepareStatement("DELETE FROM st_timetable WHERE timetable_id = ?");
            ps.setInt(1, timetableId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, String>> getAttendanceSummaryByClass(int classId, String month) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT s.student_id, s.name, s.roll_number, "
                       + "COUNT(a.attendance_id) AS total, "
                       + "SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present "
                       + "FROM st_student s "
                       + "LEFT JOIN st_attendance a ON s.student_id = a.student_id "
                       + "AND TO_CHAR(a.attendance_date, 'YYYY-MM') = ? "
                       + "WHERE s.class_id = ? "
                       + "GROUP BY s.student_id, s.name, s.roll_number "
                       + "ORDER BY s.roll_number";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, month);
            ps.setInt(2, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("student_id",  rs.getString("student_id"));
                m.put("name",        rs.getString("name"));
                m.put("roll_number", rs.getString("roll_number"));
                m.put("total",       rs.getString("total"));
                m.put("present",     rs.getString("present"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getAttendanceDetailByStudentMonth(int studentId, String month) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT TO_CHAR(attendance_date, 'YYYY-MM-DD') AS date, "
                       + "TO_CHAR(attendance_date, 'Day') AS day, status "
                       + "FROM st_attendance "
                       + "WHERE student_id = ? AND TO_CHAR(attendance_date, 'YYYY-MM') = ? "
                       + "ORDER BY attendance_date";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, month);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("date",   rs.getString("date"));
                m.put("day",    rs.getString("day").trim());
                m.put("status", rs.getString("status"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getLiveClassesByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT oc.*, t.name AS teacher_name FROM st_online_class oc LEFT JOIN st_teacher t ON oc.teacher_id = t.teacher_id WHERE oc.class_id = ? AND oc.status = 'Live' ORDER BY oc.start_time";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("subject",      rs.getString("subject"));
                m.put("class_link",   rs.getString("class_link"));
                m.put("start_time",   rs.getString("start_time"));
                m.put("end_time",     rs.getString("end_time"));
                m.put("teacher_name", rs.getString("teacher_name"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getUpcomingClassesByClass(int classId) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT oc.*, t.name AS teacher_name FROM st_online_class oc LEFT JOIN st_teacher t ON oc.teacher_id = t.teacher_id WHERE oc.class_id = ? AND oc.status = 'Scheduled' ORDER BY oc.start_time";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("subject",      rs.getString("subject"));
                m.put("class_link",   rs.getString("class_link"));
                m.put("start_time",   rs.getString("start_time"));
                m.put("end_time",     rs.getString("end_time"));
                m.put("teacher_name", rs.getString("teacher_name"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String, String>> getAllTeachers() {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Connection con = getConn();
            String sql = "SELECT teacher_id, name FROM st_teacher ORDER BY name";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("teacher_id", rs.getString("teacher_id"));
                m.put("name",       rs.getString("name"));
                list.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}