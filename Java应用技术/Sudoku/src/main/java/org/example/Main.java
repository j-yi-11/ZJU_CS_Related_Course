package org.example;

import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;
import java.io.*;
import static java.lang.System.exit;

public class Main {
    public static int[][] input_sudoku = new int[][]{
            {0 ,0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0 ,0, 0, 8, 8, 7, 0, 6, 0, 0},
            {0,0, 1, 0, 5, 6, 0, 0, 0, 0},
            {0, 0, 2, 0, 0, 0, 0, 0, 0, 1},
            {0,0, 6, 0, 0, 0, 0, 0, 0, 0},
            {0,5, 7, 1, 0, 3, 0, 4, 9, 8},
            {0,0, 0, 0, 0, 0, 0, 0,7 ,0},
            {0,4, 0, 0, 0, 0, 0, 0, 6, 0},
            {0,0, 0 ,0, 0, 4, 3, 0, 5 ,0},
            {0,0, 0, 3, 0 ,5 ,0, 2 ,0, 0}
    };
    public static int solutions = 0;
    public static int[][] known = new int[10][10];
    public static int[][] column = new int[10][10];
    public static int[][] row = new int[10][10];
    public static int[][][] block = new int[4][4][10];
    public static boolean[][] show_index = new boolean[9][9];
    public static int[] show_count = new int[9];
    public static void clear_input_data(){
        solutions = 0;
        for (int i=0;i<10;i++){
            for(int j=0;j<10;j++){
                input_sudoku[i][j] = row[i][j] = column[i][j] = 0;
            }
        }
        for(int i=0;i<9;i++) show_count[i] = 0;
        for (int i=0;i<9;i++){
            for(int j=0;j<9;j++){
                show_index[i][j] = false;
            }
        }
        for (int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                for(int k=0;k<10;k++){
                    block[i][j][k] = 0;
                }
            }
        }
    }
    public static void print_results() {
        System.out.printf("\n-------------- %d solution ---------------\n",solutions);
        for (int i = 1; i <= 9; i++) {
            for (int j = 1; j <= 9; j++) {
                System.out.print(input_sudoku[i][j]);
                if (j != 9) System.out.print(" ");
            }
            System.out.print("\n");
        }
    }
    public static void search(int x, int y) {
        if (x == 10 && y == 1) {
            solutions += 1;
            print_results();
            return;//exit(0);
        }
        if (known[x][y]==1) {
            search((9 * x + y - 9) / 9 + 1, y % 9 + 1);
        }
        else {
            for (int i = 1; i <= 9; i++) {
                if (row[x][i] == 0 && column[y][i] == 0 && block[(x - 1) / 3 + 1][(y - 1) / 3 + 1][i] == 0) {
                    input_sudoku[x][y] = i;
                    row[x][i] = 1;
                    column[y][i] = 1;
                    block[(x - 1) / 3 + 1][(y - 1) / 3 + 1][i] = 1;
                    search((9 * x + y - 9) / 9 + 1, y % 9 + 1);
                    if(solutions>0){
                        continue;
                    }
                    input_sudoku[x][y] = 0;
                    row[x][i] = 0;
                    column[y][i] = 0;
                    block[(x - 1) / 3 + 1][(y - 1) / 3 + 1][i] = 0;
                }
            }
        }
    }
    public static void main(String[] args) {
        String command = "";
        Scanner input = new Scanner(System.in);
        final int[][] existing_sudoku = new int[][] {
            {8, 1, 2, 7, 5, 3, 6, 4, 9},
            {9, 4, 3, 6, 8, 2, 1, 7, 5},
            {6, 7, 5, 4, 9, 1, 2, 8, 3},
            {1, 5, 4, 2, 3, 7, 8, 9, 6},
            {3, 6, 9, 8, 4, 5, 7, 2, 1},
            {2, 8, 7, 1, 6, 9, 5, 3, 4},
            {5, 2, 1, 9, 7, 4, 3, 6, 8},
            {4, 3, 8, 5, 2, 6, 9, 1, 7},
            {7, 9, 6, 3, 1, 8, 4, 5, 2}
        };
        while(true){
            clear_input_data();
            System.out.print("input order:\ng ==> generate sudo\ns ==> solve input sudoku from console\nf ==> solve input sudoku from file\ne ==> exit\n");
            command = input.nextLine();
            command = command.replaceAll("\\s", "");
//            System.out.println("command.length() = "+command.length());
            if(command.equals("g")){
                int number = 0;
                System.out.println("input a number between 1 and 81");
                String userInput = input.nextLine();//number = input.nextInt();
                userInput = userInput.replaceAll("\\s","");
                number = Integer.parseInt(userInput);
                System.out.println("number = "+number);
                if(number>=1 && number<=81){
                    for(int i=0;i<=8;i++){
                        show_count[i] = number/9;
                    }
                    for(int i=number%9;i>=0;i--){
                        show_count[i] += 1;
                    }
                    // index
                    for(int i=0;i<=8;i++){
                        int random_index;
                        Set<Integer> unique_number_set = new HashSet<Integer>();
                        while(unique_number_set.size() < show_count[i]){
                            random_index = (int)((9-1)*Math.random());
                            unique_number_set.add(random_index);
                        }
                        for(int it:unique_number_set){
                            show_index[i][it] = true;
                        }
                    }
                    // output
                    for(int i=0;i<=8;i++){
                        for(int j=0;j<=8;j++){
                            if(show_index[i][j]==true){
                                System.out.print(existing_sudoku[i][j]);
                            }else {
                                System.out.print(".");
                            }
                            if(j!=8) System.out.print(" ");
                            else System.out.print("\n");
                        }
                    }
                }else{
                    System.out.println("invalid number : "+number);
                }
            }
            else if (command.equals("s")) {
                System.out.println("input sudoku:");
                for(int count = 0 ;count < 81 ; count++){
                    char element = input.next().charAt(0);
                    if(element == '.'){
                        input_sudoku[1 + count / 9][1 + count % 9] = 0;
                        known[1 + count / 9][1 + count % 9] = 0;
                    }else{
                        input_sudoku[1 + count / 9][1 + count % 9] = element - '0';
                        known[1 + count / 9][1 + count % 9] = 1;
                    }
                }
                for(int i=1;i<=9;i++){
                    for(int j=1;j<=9;j++){
                        if (input_sudoku[i][j]!=0){
                            known[i][j] = 1;
                        }else
                            known[i][j] = 0;
                    }
                }
                for (int i = 1; i <= 9; i++) {
                    for (int j = 1; j <= 9; j++) {
                        if (known[i][j]==1) {
                            row[i][input_sudoku[i][j]] = 1;
                            column[j][input_sudoku[i][j]] = 1;
                            block[(i - 1) / 3 + 1][(j - 1) / 3 + 1][input_sudoku[i][j]] = 1;
                        }
                    }
                }
                //
                search(1, 1);
                if(solutions == 0) System.out.println("NO solution!");
                solutions = 0;
            }
            else if(command.equals("f")) {
                String currentDirectory = System.getProperty("user.dir");
                System.out.println("Current directory: " + currentDirectory);
                try{
                    String line = "";
                    BufferedReader reader = new BufferedReader(new FileReader("input.txt"));
                    int row_ = 0;// col = 0;
                    while ((line = reader.readLine()) != null) {
//                        System.out.println("line ="+line);
                        if (line.equals("-2")==true) {
                            search(1,1);
                            if(solutions == 0) System.out.println("NO solution!");
                            solutions = 0;
                            // Reset the grid for the next sudoku
                            clear_input_data();
                            row_ = 0;
                        } else {
                            int col = 0;
                            // Parse the line and populate the input_sudoku
                            for (int count = 0; count < line.length(); count++) {
                                char character = line.charAt(count);
                                if (Character.isSpaceChar(character)) continue;
                                if (character == '.') {
                                    input_sudoku[1+row_][1+col] = 0;
                                    known[1 + row_][1 + col] = 0;
                                } else if (Character.isDigit(character)) {
                                    input_sudoku[1+row_][1+col] = Character.getNumericValue(character);
                                    known[1 + row_][1 + col] = 1;
                                    row[1 + row_][input_sudoku[1 + row_][1 + col]] = 1;
                                    column[1 + col][input_sudoku[1 + row_][1 + col]] = 1;
                                    block[(1 + row_ - 1) / 3 + 1][(1 + col - 1) / 3 + 1][input_sudoku[1 + row_][1 + col]] = 1;
                                }
                                col++;
                            }
                            row_++;
                        }
                    }
                    reader.close();
                }catch (IOException e){
                    e.printStackTrace();
                }
            }else if (command.equals("e")) {
                System.out.println("exit");
                break;
            } else {
                System.out.println("wrong input order:"+command+"\n");
            }
            command = "";
        }
        input.close();
    }
}