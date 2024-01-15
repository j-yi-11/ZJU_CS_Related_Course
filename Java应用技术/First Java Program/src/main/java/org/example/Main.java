package org.example;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println("3210103803 蒋奕 homework 1");
//        String javaVersion = System.getProperty("java.version");
//        System.out.println("当前所使用的JDK版本是: " + javaVersion);
        Scanner sc = new Scanner(System.in);
        String command = "";
        while(true) {
            System.out.println("请输入命令 (\"hex to dec\" 或 \"dec to hex\")，或输入 \"exit\" 退出程序:");
            command = sc.nextLine().toLowerCase(); // 将命令转换为小写以不区分大小写
            if(command.equals("exit")){
                System.out.println("exited");
                break;
            }else if(command.equals("hex to dec")){
                 while(true) {
                    System.out.println("input a hex number(-1 means end): ");
                    String hex = sc.nextLine();
                    if(hex.equals("-1")){
                        System.out.println("program ended!");
                        break;
                    }
                    //try {
                        int dec = Integer.parseInt(hex, 16);
                        System.out.println("hex "+hex+" in dec form is : "+dec);
//                    }catch (NumberFormatException e){
//                        System.out.println("invalid input hex");
//                    }
                }
            }else if(command.equals("dec to hex")){
                while(true){
                    System.out.println("input a decimal number(-1 means end): ");
                    int decimal = sc.nextInt();
                    if(decimal == -1)
                    {
                        System.out.println("program ended!");
                        break;
                    }
                    //try{
                        String hex = Integer.toHexString(decimal);
                        System.out.println("dec "+decimal+" in hex form is : "+hex);
//                    }catch(NumberFormatException e){
//                        System.out.println("invalid input dec");
//                    }
                }
            }else {
                System.out.println("invalid command : "+command);
            }
        }
        sc.close();
    }
}