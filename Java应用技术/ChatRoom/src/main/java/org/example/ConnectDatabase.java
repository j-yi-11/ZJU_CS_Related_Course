package org.example;
import java.sql.*;
import java.time.LocalDateTime;

public class ConnectDatabase {
    private Connection connection = null;                  // Connection to database
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/chat";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "jjh2002jy";

    public ConnectDatabase(){
        this(DEFAULT_URL,DEFAULT_USERNAME,DEFAULT_PASSWORD);
    }
    public ConnectDatabase(String url, String username, String password){
        //将MySQL数据库驱动名称封装在字符串中
        String driver = "com.mysql.cj.jdbc.Driver";
        //指定使用数据库的路径
        String JDBCurl = url;
        //指定登录账户
        String user = username;
        //指定账户密码
        String psw = password;
        //加载数据库驱动
        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        //连接数据库
        try{
            this.connection = DriverManager.getConnection(JDBCurl,user,psw);
        }catch (SQLException e){
            System.out.println("SQL exception when constructing");
        }
    }

    public Connection getConnection() {
        return this.connection;
    }
    // 关闭连接
    public void closeConnection() {
        if (this.connection != null) {
            try {
                this.connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    void insertData(String userName, String message) {
        String insertSQL = "INSERT INTO ChatRoomInfo (userName, message, time) VALUES (?, ?, ?)";
        try{
            this.connection.setAutoCommit(false); // 开始事务
            try (PreparedStatement preparedStatement = this.connection.prepareStatement(insertSQL)) {
                preparedStatement.setString(1, userName);
                preparedStatement.setString(2, message);
                preparedStatement.setObject(3, LocalDateTime.now());
                preparedStatement.executeUpdate();
                System.out.println("Data inserted successfully!");
                this.connection.commit(); // 提交事务
            }catch (SQLException e){
                this.connection.rollback(); // 回滚事务
                System.out.println("insertdata error"+e);
            }finally {
                this.connection.setAutoCommit(true); // 恢复自动提交
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    // 查询数据
    void queryData(String condition) throws SQLException {
        String countSQL = "SELECT COUNT(*) AS total FROM ChatRoomInfo WHERE " + condition;
        String querySQL = "SELECT * FROM ChatRoomInfo "+" where "+condition;
        String seperator = "----------------------------";
        try{
            this.connection.setAutoCommit(false);
            try (Statement countStatement = this.connection.createStatement(); ResultSet countResult = countStatement.executeQuery(countSQL)) {
                // 获取总记录数
                int totalRecords = 0;
                if (countResult.next()) {
                    totalRecords = countResult.getInt("total");
                }
                System.out.println("Total Records: " + totalRecords);
                this.connection.commit();
            }catch (Exception e){
                this.connection.rollback();
                e.printStackTrace();
            }finally {
                this.connection.setAutoCommit(true);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        try{
            this.connection.setAutoCommit(false);
            try (Statement statement = this.getConnection().createStatement()) {//this.connection
                try (var resultSet = statement.executeQuery(querySQL)) {
                    System.out.println("Query Result:");
                    while (resultSet.next()) {
                        String userName = resultSet.getString("userName");
                        String message = resultSet.getString("message");
                        String time = resultSet.getString("time");
                        System.out.println(seperator);
                        System.out.println("UserName: " + userName + "\nMessage: " + message + "\nTime: " + time);
                        System.out.println(seperator+"\n");
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }
                this.connection.commit();
            }catch (Exception e){
                this.connection.rollback();
                System.out.println("queryData error!"+e);
            }finally {
                this.connection.setAutoCommit(true);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    // 删除数据
    void deleteData(String userName) {
        String deleteSQL = "DELETE FROM ChatRoomInfo WHERE userName = ?";
        try{
            this.connection.setAutoCommit(false);
            try (PreparedStatement preparedStatement = this.connection.prepareStatement(deleteSQL)) {
                preparedStatement.setString(1, userName);
                preparedStatement.executeUpdate();
                System.out.println("data deleted successfully!");
                this.connection.commit();
            }catch (SQLException e){
                this.connection.rollback();
                System.out.println("deleteData error!"+e);
            }finally{
                this.connection.setAutoCommit(true);
            }
        }catch (Exception e){
            e.printStackTrace();
        }

    }
}
