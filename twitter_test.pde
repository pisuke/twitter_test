import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;

int time_refresh = 30000;

String fearSearchString = "fear";
String loveSearchString = "love";

//String fearSearchString = "source:aruplightlab";
//String loveSearchString = "source:aruplightlab";

Twitter twitter;

List<Status> fear_tweets;
List<Status> love_tweets;
List<Status> home_tweets;

int currentFearTweet;
int currentLoveTweet;
int currentHomeTweet;

color fear_color = color(0,255,0);
color love_color = color(255,0,255);
color home_color = color(255,255,255);

String imgTemp = null;

void setup()
{
    //size(800,600);
    background(0);
    fullScreen();
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("8gwWMe6zG63lqmwYZaRUibf0a");
    cb.setOAuthConsumerSecret("Ibnnj7wjAwgiltf903iPJDiMxSzeREmCQURN7XnCTN9D1s96VV");
    cb.setOAuthAccessToken("793523469535350784-uYIBol8DMbNWdww3rRxs6oPNQ7dvh7u");
    cb.setOAuthAccessTokenSecret("cVzj7Klp8xCJphANaDO7PZoosi44UOUJjqHnNy9QfYiqr");
    TwitterFactory tf = new TwitterFactory(cb.build());
    twitter = tf.getInstance();
    //twitter = TwitterFactory.getSingleton();
    
    getNewTweets();
    currentFearTweet = 0;
    currentLoveTweet = 0;
    currentHomeTweet = 0;
    thread("refreshTweets");
}

void draw()
{
  
  
  fill(0, 30);
  rect(0, 0, width, height);  
  
  //Status fearStatus = fear_tweets.get(currentFearTweet);
  //fill(fear_color);
  float x = random(width);
  float y = random(height); 
  //drawTweet(fearStatus, x, y);
  //delay(100);
  //currentFearTweet = currentFearTweet + 1;
  //if (currentFearTweet >= fear_tweets.size())
  //{
  //    println(fear_tweets.size());
  //    currentFearTweet = 0;
  //}

  //Status loveStatus = love_tweets.get(currentLoveTweet);
  //fill(love_color);
  //x = random(width);
  //y = random(height);
  //drawTweet(loveStatus, x, y);
  //delay(100);
  //currentLoveTweet = currentLoveTweet + 1;
  //if (currentLoveTweet >= love_tweets.size())
  //{
  //    currentLoveTweet = 0;
  //}
  
  Status homeStatus = home_tweets.get(currentHomeTweet);
  fill(home_color);
  x = random(width);
  y = random(height);
  drawTweet(homeStatus, x, y);
  delay(30);
  currentHomeTweet = currentHomeTweet + 1;
  if (currentHomeTweet >= home_tweets.size())
  {
      currentHomeTweet = 0;
  }
  
}

void getNewTweets()
{
  try
  {
      // try to get tweets here
      Query fearQuery = new Query(fearSearchString);      
      fearQuery.setCount(20);
      Query loveQuery = new Query(loveSearchString);
      loveQuery.setCount(20);
      QueryResult fearResult = twitter.search(fearQuery);
      QueryResult loveResult = twitter.search(loveQuery);
      fear_tweets = fearResult.getTweets();
      love_tweets = loveResult.getTweets();
      println(love_tweets);
      println(fear_tweets);
      Paging paging = new Paging(1,1000);
      home_tweets = twitter.getUserTimeline(paging);
      print("home_tweets: ");
      println(home_tweets);
      println(home_tweets.size());

  }
  catch (TwitterException te)
  {
      // deal with the case where we can't get them here
      System.out.println("Failed to search tweets: " + te.getMessage());
      //System.exit(-1);
  }


}

void refreshTweets()
{
    while (true)
    {
        getNewTweets();

        println("Updated Tweets");

        delay(time_refresh);
    }
}

void drawTweet(Status thisStatus, float x, float y)
{
  MediaEntity[] media_entity = thisStatus.getMediaEntities();
  HashtagEntity[] hashtags_entity = thisStatus.getHashtagEntities();
  
  if (media_entity.length>0) {
    //println(media_entity.size());
    //if 
    MediaEntity media = media_entity[0];
    String imageURL = media.getMediaURL();
    PImage img = loadImage(imageURL); 
    int w = media.getSizes().get(1).getWidth();
    int h = media.getSizes().get(1).getHeight();
    image(img, x, y, w/3, h/3);
    String hashtags_text = "";
    if (hashtags_entity.length>0) {
      for (int j=0; j<hashtags_entity.length; j++) {
        HashtagEntity hashtag = hashtags_entity[j];
        hashtags_text += hashtag.getText()+" ";
      }
    }
    text(thisStatus.getText()+" "+hashtags_text, x, y+img.height/3, 300, 200);
    //println("Array: "+fear_media);
    //println(fear_media.length);
    println(hashtags_text);
  }
}