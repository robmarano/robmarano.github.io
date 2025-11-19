import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

public class WordCounterMaster {

    public static void main(String[] args) throws IOException, InterruptedException {
        String directoryPath = "text_files"; // Replace with your directory
        File sharedFile = new File("word_counts.txt");
        sharedFile.createNewFile();

        List<Process> processes = new ArrayList<>();
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(directoryPath), "*.txt")) {
            for (Path filePath : stream) {
                ProcessBuilder pb = new ProcessBuilder("java", "WordCounterWorker", filePath.toString(), sharedFile.getAbsolutePath());
                Process p = pb.start();
                processes.add(p);
            }
        }

        for (Process p : processes) {
            p.waitFor();
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(sharedFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        }

        System.out.println("Word counting completed.");
    }
}