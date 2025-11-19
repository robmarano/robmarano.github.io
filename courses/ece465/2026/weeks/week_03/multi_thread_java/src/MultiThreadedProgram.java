import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class MultiThreadedProgram {

    private List<Integer> sharedData = new ArrayList<>();
    private boolean dataReady = false;

    public static void main(String[] args) {
        MultiThreadedProgram program = new MultiThreadedProgram();
        program.startThreads();
    }

    public void startThreads() {
        Thread producerThread = new Thread(new Producer2());
        Thread consumerThread = new Thread(new Consumer());

        producerThread.start();
        consumerThread.start();
    }

    class Producer implements Runnable {
        @Override
        public void run() {
            for (int i = 1; i <= 5; i++) {
                synchronized (sharedData) {
                    sharedData.add(i);
                    System.out.println("Producer added: " + i);
                    dataReady = true;
                    sharedData.notifyAll(); // Notify consumers that data is available
                }
                try {
                    Thread.sleep(1000); // Simulate some work
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }

    class Producer2 implements Runnable {
        @Override
        public void run() {
            Random random = new Random();
            // Generate a random integer
            int randomInt;
                try {
                    randomInt = random.nextInt(5);
                    synchronized (sharedData) {
                        sharedData.add(randomInt);
                        System.out.println("Producer added: " + randomInt);
                        dataReady = true;
                        sharedData.notifyAll(); // Notify consumers that data is available
                    Thread.sleep(randomInt*100); // Simulate some work
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
        }
    }

    class Consumer implements Runnable {
        @Override
        public void run() {
            while (true) {
                synchronized (sharedData) {
                    while (!dataReady) {
                        try {
                            sharedData.wait(); // Wait for data to become available
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                    if (!sharedData.isEmpty()) {
                        int data = sharedData.remove(0);
                        System.out.println("Consumer processed: " + data);
                    }
                    if(sharedData.isEmpty()){
                        dataReady = false;
                    }
                }
                try {
                    Thread.sleep(500); // Simulate processing
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }
}