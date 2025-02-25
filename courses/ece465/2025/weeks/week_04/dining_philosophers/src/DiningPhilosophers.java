import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.atomic.AtomicInteger;

class Chopstick {
    private Lock lock = new ReentrantLock();

    public boolean pickUp() {
        return lock.tryLock();
    }

    public void putDown() {
        lock.unlock();
    }
}

class Philosopher extends Thread {
    private int id;
    private Chopstick leftChopstick;
    private Chopstick rightChopstick;
    private AtomicInteger eatCount;
    private AtomicInteger totalEatCount;
    private int numberOfPhilosophers;

    public Philosopher(int id, Chopstick leftChopstick, Chopstick rightChopstick, AtomicInteger eatCount, AtomicInteger totalEatCount, int numberOfPhilosophers) {
        this.id = id;
        this.leftChopstick = leftChopstick;
        this.rightChopstick = rightChopstick;
        this.eatCount = eatCount;
        this.totalEatCount = totalEatCount;
        this.numberOfPhilosophers = numberOfPhilosophers;
    }

    @Override
    public void run() {
        try {
            while (totalEatCount.get() < numberOfPhilosophers) {
                think();
                eat();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private void think() throws InterruptedException {
        System.out.println("Philosopher " + id + " is thinking.");
        Thread.sleep((long) (Math.random() * 100));
    }

    private void eat() throws InterruptedException {
        if (eatCount.get() > 0) {
            return;
        }

        boolean leftPicked = false;
        boolean rightPicked = false;

        // if (id == 4) {
        //     leftPicked = rightChopstick.pickUp();
        //     if (leftPicked) {
        //         System.out.println("Philosopher " + id + " picked up left chopstick.");
        //         rightPicked = leftChopstick.pickUp();
        //         if (rightPicked == false) {
        //             rightChopstick.putDown();
        //             leftPicked = false;
        //         } else {
        //             System.out.println("Philosopher " + id + " picked up right chopstick.");
        //         }
        //     }
        // } else {
        leftPicked = leftChopstick.pickUp();
        if (leftPicked) {
            System.out.println("Philosopher " + id + " picked up left chopstick.");
            rightPicked = rightChopstick.pickUp();
            if (rightPicked == false) {
                leftChopstick.putDown();
                leftPicked = false;
            } else {
                System.out.println("Philosopher " + id + " picked up right chopstick.");
            }
        }
        // }

        if (leftPicked && rightPicked) {
            System.out.println("Philosopher " + id + " is eating.");
            Thread.sleep((long) (Math.random() * 100));
            leftChopstick.putDown();
            rightChopstick.putDown();
            eatCount.incrementAndGet();
            totalEatCount.incrementAndGet();
            System.out.println("Philosopher " + id + " is finished.");
        }
    }
}

public class DiningPhilosophers {
    public static void main(String[] args) {
        int numberOfPhilosophers = 13;
        Chopstick[] chopsticks = new Chopstick[numberOfPhilosophers];
        Philosopher[] philosophers = new Philosopher[numberOfPhilosophers];
        AtomicInteger[] eatCounts = new AtomicInteger[numberOfPhilosophers];
        AtomicInteger totalEatCount = new AtomicInteger(0);

        for (int i = 0; i < numberOfPhilosophers; i++) {
            chopsticks[i] = new Chopstick();
            eatCounts[i] = new AtomicInteger(0);
        }

        for (int i = 0; i < numberOfPhilosophers; i++) {
            philosophers[i] = new Philosopher(i, chopsticks[i], chopsticks[(i + 1) % numberOfPhilosophers], eatCounts[i], totalEatCount, numberOfPhilosophers);
            philosophers[i].start();
        }

        try {
            for (Philosopher philosopher : philosophers) {
                philosopher.join();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        System.out.println("All philosophers have eaten. Simulation ended.");
    }
}