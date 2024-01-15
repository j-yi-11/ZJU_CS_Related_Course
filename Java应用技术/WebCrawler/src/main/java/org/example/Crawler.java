package org.example;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Vector;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
/**
 * Crawler class is designed to crawl ArXiv search result pages, extract PDF URLs, and download the corresponding PDF files.
 */
public class Crawler{
    /**
     * Main method to initiate the crawling process for a list of ArXiv search result URLs.
     *
     * @param args Command-line arguments (not used in this case).
     * @throws Exception If an error occurs during the crawling process.
     */
    public static void main(String[] args) throws Exception{
        Vector<String> urlList = new Vector<>();
        urlList.add("https://arxiv.org/search/cs?query=chain+of+thought&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        urlList.add("https://arxiv.org/search/cs?query=3d+reconstruction&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        urlList.add("https://arxiv.org/search/cs?query=deepfake+detection&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        String paperDir = "D:/papers/";
        for(String url:urlList){
            System.out.println("url is "+url);
            Document doc = Jsoup.connect(url).get();
            Elements pdfElements = doc.select("li.arxiv-result");
            System.out.println("pdf elements size: "+pdfElements.size());
            for (Element pdfElement : pdfElements) {
                // Extract PDF URL from <a> element
                Element pdfLinkElement = pdfElement.selectFirst("a[href]");

                if (pdfLinkElement != null) {
                    String pdfUrl = pdfLinkElement.absUrl("href");

                    // Check if the link text or parent element text contains the "pdf" string
                    if (pdfLinkElement.parent().text().toLowerCase().contains("pdf")) {
                        String final_url = pdfUrl.replace("/abs/","/pdf/");
                        System.out.println("PDF URL: " + final_url);// ||pdfLinkElement.text().toLowerCase().contains("pdf")
                        String fileID = final_url.substring(final_url.lastIndexOf('/')+1);
                        System.out.println("file name is: "+fileID);
                        String fileName = paperDir+fileID+".pdf";
                        URL downloadUrl = new URL(final_url);
                        InputStream in = downloadUrl.openStream();
                        Files.copy(in, new File(fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        System.out.println("File saved to: " + fileName);
                    }
                }
            }
        }
    }
}