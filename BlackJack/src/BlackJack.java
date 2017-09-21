import java.util.InputMismatchException;
import java.util.Random;
import java.util.Scanner;


public class BlackJack {
    public static void main(String[] args)
    {
        int exitInt = 0;
        int numberOfGames = 0;
        int playerNum;
        int cardValue = 0;
        int dealerHand = 0;
        int playerWins = 0;
        int dealerWins = 0;
        int numberTies = 0;
        //int gamePlaying = 1;
        String playerCard;
        Random rand = new Random();
        Scanner scnr = new Scanner(System.in);

        while (exitInt == 0)
        {

            int gamePlaying = 1;


            //Print Start Game
            ++numberOfGames;
            System.out.println("\nSTART GAME #" + numberOfGames);

            playerNum = rand.nextInt(13) + 1;

            switch (playerNum)
            {
                case 1: playerCard = "ACE!";
                        cardValue = playerNum;
                        break;
                case 11: playerCard = "JACK!";
                        cardValue = 10;
                        break;
                case 12: playerCard = "QUEEN!";
                         cardValue = 10;
                        break;
                case 13: playerCard = "KING!";
                        cardValue = 10;
                        break;
                default: playerCard = playerNum + "!";
                        cardValue = playerNum;
                        break;
            }
            System.out.println("\nYour card is a " + playerCard);
            System.out.println("Your hand is: " + cardValue);


            int optionNumber = 0;
            while(gamePlaying == 1)
            {
                int menuFlag = 1;

                while (menuFlag == 1) {
                    //print menu
                    //System.out.println("`````````````````````````````");
                    System.out.println("\n1. Get another card");
                    System.out.println("2. Hold hand");
                    System.out.println("3. Print statistics");
                    System.out.println("4. Exit");

                    System.out.print("\nChoose an option: ");

                   try {
                        optionNumber = scnr.nextInt();
                        if (optionNumber >= 1 && optionNumber <= 4) {
                            menuFlag = 0;
                        }else
                            System.out.println("\nInvalid input! \nPlease enter an integer value between 1 and 4.");
                    }
                    catch (InputMismatchException e)
                    {
                        System.out.println("\nInvalid input! \nPlease enter an integer value between 1 and 4.");
                        scnr.nextLine();
                    }
                }

                switch (optionNumber) {
                    case 1: {
                        playerNum = rand.nextInt(13) + 1;

                        switch (playerNum) {
                            case 1:
                                playerCard = "ACE!";
                                cardValue += playerNum;
                                break;
                            case 11:
                                playerCard = "JACK!";
                                cardValue += 10;
                                break;
                            case 12:
                                playerCard = "QUEEN!";
                                cardValue += 10;
                                break;
                            case 13:
                                playerCard = "KING!";
                                cardValue += 10;
                                break;
                            default:
                                playerCard = playerNum + "!";
                                cardValue += playerNum;
                                break;
                        }
                        System.out.println("\nYour card is a " + playerCard);
                        System.out.println("Your hand is: " + cardValue);
                        if (cardValue == 21)
                        {
                            playerWins++;
                            System.out.println("\nBLACKJACK! You win!");
                            gamePlaying = 0;
                        }else if (cardValue > 21)
                        {
                            dealerWins++;
                            System.out.println("\nYou exceeded 21! You lose :(");
                            gamePlaying = 0;
                        }
                        break;
                    }
                    case 2: {
                        dealerHand = rand.nextInt(11) + 16;
                        System.out.println("\nDealer's hand: " + dealerHand);
                        System.out.println("Your hand is: " + cardValue);

                        if (dealerHand > 21) {
                            playerWins++;
                            System.out.println("\nYou win!");
                        } else if (dealerHand == cardValue) {
                            numberTies++;
                            System.out.println("\nIt's a tie! No one wins!");
                        } else {
                            if (dealerHand > cardValue) {
                                dealerWins++;
                                System.out.println("\nDealer wins!");
                            } else {
                                playerWins++;
                                System.out.println("\nYou win!");
                            }

                        }
                        gamePlaying = 0;
                        break;
                    }
                    case 3: {
                        System.out.println("\nNumber of Player wins: " + playerWins);
                        System.out.println("Number of Dealer wins: " + dealerWins);
                        System.out.println("Number of tie games: " + numberTies);
                        System.out.println("Total # of games played is: " + (numberOfGames - 1) );
                        System.out.println("Percentage of Player wins: " + (1.0 * playerWins / (numberOfGames - 1) * 100) + "%");

                        break;
                    }
                    case 4: {
                        exitInt = 1;
                        gamePlaying = 0;
                        break;
                    }
                }

            }
        }

    }

}
