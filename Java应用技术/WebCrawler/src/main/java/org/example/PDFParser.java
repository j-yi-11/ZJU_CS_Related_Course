package org.example;
// https://blog.csdn.net/henku449141932/article/details/130111514
import org.apache.pdfbox.cos.COSName;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.common.PDStream;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.apache.pdfbox.text.PDFTextStripper;
import javax.imageio.ImageIO;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
/**
 * PDFParser class is designed to parse PDF files, extract text content, and save the content to text files.
 * Additionally, it extracts images from the PDF and saves them as PNG files.
 */
public class PDFParser {
     /**
     * Main method that processes PDF files from the specified directory, extracts text, and saves it to text files.
     * It also extracts images from the PDF and saves them in the specified directory.
     *
     * @param args Command-line arguments (not used in this case).
     */
    public static void main(String[] args) {
        String paperDir = "D:/papers/";
        String paperParseDir = "D:/papers_parser/";
        String fileName="2311.09799.pdf";
        String fileFullName=paperDir+fileName;

        List<String> pdfFiles = new ArrayList<>();
        int count = 0;
        File directory = new File(paperDir);
        File[] files = directory.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isFile() && file.getName().toLowerCase().endsWith(".pdf")) {
                    pdfFiles.add(file.getName());
                    try {
                        readPDF(paperDir, file.getName(), paperParseDir);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    System.out.println("count is : "+count++);
                }
            }
        }
        System.out.println("number of pdf : "+pdfFiles.size());
    }
    /**
     * Reads a PDF file, extracts text content, and saves it to a text file. It also extracts images from the PDF
     * and saves them as PNG files.
     *
     * @param paperDir    Directory path where PDF files are stored.
     * @param fileName_   Name of the PDF file to be processed.
     * @param outPath     Directory path to save the parsed text and images.
     */
    public static void readPDF(String paperDir, String fileName_,String outPath) {
        String fileName = paperDir+fileName_;
        System.out.println("file name is: "+fileName);
        File file = new File(fileName);
        FileInputStream in = null;
        try {
            PDDocument pdfdocument = PDDocument.load(file);
            // get page number
            int pageNumbers = pdfdocument.getNumberOfPages();
            System.out.println("total page number: "+pageNumbers);
            // strip the text
            PDFTextStripper stripper = new PDFTextStripper();
            // set read by line
            stripper.setSortByPosition(true);
            // write text to file
            String temp = fileName_.replace(".pdf",".txt");
            String textParserResultPath = outPath+temp;
            File textParserResult = new File(textParserResultPath);
            FileWriter fileWriter = new FileWriter(textParserResult);
            // begin to strip page
            for(int i=1;i<=pageNumbers;i++)
            {
                // read text and write to file
                stripper.setStartPage(i);
                stripper.setEndPage(i);
                String result = stripper.getText(pdfdocument);
                fileWriter.write(result);
                fileWriter.flush();
                // get images
                PDPage page = pdfdocument.getPage(i-1);
                PDResources pdResources = page.getResources();
                int imageCountNumber = 0;
                for(COSName csName : pdResources.getXObjectNames())
                {
                    PDXObject pdxObject = pdResources.getXObject(csName);
                    if(pdxObject instanceof PDImageXObject){
                        PDStream pdStream = pdxObject.getStream();
                        PDImageXObject image = new PDImageXObject(pdStream, pdResources);
                        String imageFilePath = String.format(outPath+
                                fileName_.substring(0, fileName_.lastIndexOf('.'))
                                +"page%d-image%d.png", i,imageCountNumber);
                        File imgFile = new File(imageFilePath);
                        ImageIO.write(image.getImage(), "png", imgFile);
                        imageCountNumber++;
                    }
                }
            }
            fileWriter.close();
            pdfdocument.close(); 
        }
        catch (Exception e) {
            System.out.println("读取PDF文件" + file.getAbsolutePath() + "失败！" + e);
            e.printStackTrace();
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e1) {
                }
            }
        }
    }

}