import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

public class WordCounterWorker {

    public static void main(String[] args) throws IOException {
        String filePath = args[0];
        String sharedFilePath = args[1];

        try (Stream<String> lines = Files.lines(Paths.get(filePath))) {
            long wordCount = lines.flatMap(line -> Stream.of(line.split("\\s+"))).filter(word -> !word.isEmpty()).count();

            try (FileWriter writer = new FileWriter(sharedFilePath, true)) {
                String fileName = Paths.get(filePath).getFileName().toString();
                writer.write(fileName + ": " + wordCount + " words\n");
            }
        }
    }
}