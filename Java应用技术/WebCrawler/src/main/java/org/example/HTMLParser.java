//for .html file
package org.example;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileWriter;
import java.io.IOException;
import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.Vector;
/**
 * HTMLParser class is responsible for parsing HTML documents from ArXiv search result pages.
 */
public class HTMLParser {
     /**
     * Main method to initiate the HTML parsing process for a list of ArXiv search result URLs.
     *
     * @param args Command-line arguments (not used in this case).
     */
    public static void main(String[] args) {
        Vector<String> urlList = new Vector<>();
        urlList.add("https://arxiv.org/search/cs?query=chain+of+thought&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        urlList.add("https://arxiv.org/search/cs?query=large+language+model&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        urlList.add("https://arxiv.org/search/cs?query=language+model+evaluation&searchtype=all&abstracts=show&order=-announced_date_first&size=50");
        String HTMLParserDir = "D:/HTML_parser/";
        try {
            for(int i=0;i<urlList.size();i++) {
                 // Connect to the URL using Jsoup and get the HTML document
                Document document = Jsoup.connect(urlList.get(i)).get();
                // Call the method to parse the HTML document
                parseArxivPaper(document,HTMLParserDir);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    /**
     * Parse ArXiv papers from the HTML document and write relevant information to text files.
     *
     * @param document   The HTML document to be parsed.
     * @param outputDir  The directory where the parsed information will be saved.
     */
    private static void parseArxivPaper(Document document, String outputDir) {
        // Get all the useful HTML elements representing ArXiv paper listings
        Elements usefulElements = document.select("li.arxiv-result");
        for(Element singleElement : usefulElements){
            // Extract ArXiv ID from the link element
            Element arxivIdElement = singleElement.selectFirst("p.list-title a[href^=\"https://arxiv.org/abs/\"]");
            String arxivId = arxivIdElement.text().replace("arXiv:", "");
            // Extract paper title
            Element titleElement = singleElement.select("p.title.is-5.mathjax").first();
            String title = titleElement.text();
            // Extract author list
            Element authorListElement = singleElement.select("p.authors").first();
            Elements authorElements = authorListElement.select("a");
            Vector<String> authorList = new Vector<>();
            authorList.clear();
            for(Element authorElement : authorElements){
                authorList.addElement(authorElement.text());
            }
            int count = 0;
            for(Element authorElement : authorElements){
                count++;
            }

            // Extract abstract
            Element abstractElement = singleElement.select("span.abstract-full.has-text-grey-dark.mathjax").first();

            // Extract conference information
            Element commentsElement = singleElement.select("p.comments.is-size-7").first();
            String spanText = "";
            if (commentsElement != null) {
                Element spanElement = commentsElement.select("span.has-text-grey-dark.mathjax").first();
                if (spanElement != null) {
                    spanText = spanElement.text();
                } else {
                    System.out.println("Comments: Span element not found");
                }
            } else {
               System.out.println("Comments: Not available");
            }
            try {
                // Create the file path using arxivId and outputDir
                String filePath = outputDir + arxivId + ".txt";
                // Write the content to the file
                BufferedWriter writer = new BufferedWriter(new FileWriter(filePath));
                writer.write("Title: " + title + "\n");
                writer.write("Authors: " + String.join(", ", authorList) + "\n");
                writer.write("Abstract: " + abstractElement.text() + "\n");
                writer.write("Comments: " + spanText + "\n");
                writer.close();
                System.out.println("File saved: " + filePath);
            }catch (IOException e){
                e.printStackTrace();
            }
            System.out.println("\n");
        }
    }
}
