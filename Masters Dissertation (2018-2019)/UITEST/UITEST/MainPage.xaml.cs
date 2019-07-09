using RadialMenuControl.UserControl;
using Reddit;
using Reddit.Controllers;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Threading.Tasks;
using Tweetinvi;
using Tweetinvi.Models;
using Windows.ApplicationModel.Core;
using Windows.Devices.Input.Preview;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;


namespace UITEST
{

    //Class contains all information for a news item placed in the central feed
    public class newsEntry
    {
        public string socialMediaType { get; set; }
        public string newsItemType { get; set; }
        public string newsText { get; set; }
        public string buttonName { get; set; }
        public string id { get; set; }
        public int fontSize { get; set; }
        public Color Color { get; set; }

        //This method returns SolidColorBrush to change the colour of the text on the tags, depending on the social media type.
        public static SolidColorBrush socialMediaTextColour(string socialMediaType)
        {
            if (socialMediaType == "Twitter")
            {
                return new SolidColorBrush(Color.FromArgb(255, Convert.ToByte("#ffffff".Substring(1, 2), 16),
                Convert.ToByte("#ffffff".Substring(3, 2), 16),
                Convert.ToByte("#ffffff".Substring(5, 2), 16)));
            }
            else if (socialMediaType == "Reddit")
            {
                return new SolidColorBrush(Color.FromArgb(255, Convert.ToByte("#000000".Substring(1, 2), 16),
               Convert.ToByte("#000000".Substring(3, 2), 16),
               Convert.ToByte("#000000".Substring(5, 2), 16)));
            }
            else
            {
                return new SolidColorBrush(Colors.White);
            }
        }

        //This method returns SolidColorBrush to change the colour of the rectangle representing the social media platform.
        public static SolidColorBrush SocialColour(string socialMediaType)
        {
            if (socialMediaType == "Twitter")
            {
                return new SolidColorBrush(Color.FromArgb(255, Convert.ToByte("#1DA1F2".Substring(1, 2), 16),
                Convert.ToByte("#1DA1F2".Substring(3, 2), 16),
                Convert.ToByte("#1DA1F2".Substring(5, 2), 16)));
            }
            else if (socialMediaType == "Reddit")
            {
                return new SolidColorBrush(Color.FromArgb(255, Convert.ToByte("#ff4301".Substring(1, 2), 16),
               Convert.ToByte("#ff4301".Substring(3, 2), 16),
               Convert.ToByte("#ff4301".Substring(5, 2), 16)));
            }
            else
            {
                return new SolidColorBrush(Colors.White);
            }
        }

        //This method returns SolidColorBrush to change the colour of the rectangle representing the tag category.
        public static SolidColorBrush NewsItemColour(string newsItemType)
        {
            if (newsItemType == "News")
            {
                return new SolidColorBrush(Colors.Red);
            }
            else if (newsItemType == "tech")
            {
                return new SolidColorBrush(Colors.Purple);
            }
            else if (newsItemType == "Sport")
            {
                return new SolidColorBrush(Colors.Yellow);
            }
            else if (newsItemType == "Food")
            {
                return new SolidColorBrush(Colors.BurlyWood);
            }
            else if (newsItemType == "Uni")
            {
                return new SolidColorBrush(Colors.Azure);
            }
            else
            {
                return new SolidColorBrush(Colors.White);
            }
        }
    }

    public sealed partial class MainPage : Page
    {


        //Defining objects to handle input stream from eye tracker
        private GazeInputSourcePreview gazeInputSource;
        private GazeDeviceWatcherPreview gazeDeviceWatcher;

        DispatcherTimer timerGaze = new DispatcherTimer();

        //Boolean values to be used during filtering process.
        bool anyMenuOpen = false;
        bool shareOptionbool = false;
        bool commentOptionbool = false;
        bool likeOptionbool = false;
        bool postOptionbool = false;
        bool twitterBool = false;
        bool redditBool = false;
        bool sportBool = false;
        bool techBool = false;
        bool newsBool = false;
        bool uniBool = false;
        bool foodBool = false;

        //Boolean to share state of system in regards to interacting with socail media apis.
        bool canShare = true;
        bool canPost = true;

        //Variables to be used during user study to record time and accuracy data.
        String textForFile = "";
        String fileText = "";
        int stageOfExperiment = 1;
        int numberofExperimentalLikes = 0;
        bool experimentRunning = true;
        bool firstExit = true;
        bool timerStarted = false;
        double numberOfClicks = 0;      
        string[] timeStamps = new string[10];
        Stopwatch sw;

        //Strings to define the current fucntion of each wedge section in the react menu.
        String wedge1Function = "";
        String wedge2Function = "";
        String wedge3Function = "";
        String wedge4Function = "";

        int totalOptionsSelected = 0;
        int dwellTime = 1;
        int buttonCounter = 0;
        
        // Handles the dwellable locations on the screen and the react buttons attached to posts.
        String currentButton = "";
        String firstSetUP = "true";
        String replyMessage = "";
        String currentWedge = "none";
        String prevWedge = "none";
        List<String> buttonNameList = new List<String>();
        List<double[]> buttonPosList = new List<double[]>();
        List<double[]> buttonRealPostList = new List<double[]>();
        List<String> buttonRealNameList = new List<String>();
        int currentCount = 0;
        String section = "";

        //Values to offset coodrinates of eye tracker to cartesian grid.
        int radialMenuX = (int)((Window.Current.Bounds.Width) / 2) - 540;
        int radialMenuY = 0;
       
        
        //Lists are used to store posts when obtained from social media APIs.
        private List<Post> topPosts = new List<Post>();
        List<Post> tempPosts = new List<Post>();

        //Social media platform current post being dwelled on is from.
        String currentMedium = "";

        //Variables defined in order to temporaily save posts in order to repost or share them.
        int count = 0;
        IEnumerable<ITweet> timelineTweets;
        private ITweet tweetToUse;
        private Post redditPostToUse;
        private RedditAPI reddit;

        //Intialising of program when launched.
        //All menus are positioned correctly and data from save file is read in.
        public MainPage()
        {
            this.InitializeComponent();
            TranslateTransform translateEllipse1 = new TranslateTransform
            {
                X = radialMenuX,
                Y = radialMenuY
            };

            //Each Menu rendertransformed using Translatetransform object.
            radialMenu4Items.RenderTransform = translateEllipse1;
            radialMenu3Items.RenderTransform = translateEllipse1;
            radialMenu2Items.RenderTransform = translateEllipse1;
            radialMenu1Items.RenderTransform = translateEllipse1;
            socialMediaOptions.RenderTransform = translateEllipse1;
            filterOptionsMenu.RenderTransform = translateEllipse1;
            dwellOptionsMenu.RenderTransform = translateEllipse1;
            otherOptionsMenu.RenderTransform = translateEllipse1;

            //Reading in text from save file at textFileName address.
            //Change setttings of program depending on save file contents.
            //Settings that can be changed is current features, dwell time and filters applied.
            string textFileName = @"H:\Documents\5_Year\MastersDiss\Saves\save.txt";

            if (File.Exists(textFileName))
            {
                fileText = File.ReadAllText(textFileName);
            }
            if (fileText.Contains("slowDwell"))
            {
                dwellTime = 5;
            }
            else if (fileText.Contains("mediumDwell"))
            {
                dwellTime = 8;
            }
            else if (fileText.Contains("fastDwell"))
            {
                dwellTime = 10;
            }
            if (fileText.Contains("like"))
            {
                likeOptionbool = true;
            }
            if (fileText.Contains("comment"))
            {
                commentOptionbool = true;
            }
            if (fileText.Contains("share"))
            {
                shareOptionbool = true;
            }
            if (fileText.Contains("post"))
            {
                postOptionbool = true;
            }
            if (fileText.Contains("sport"))
            {
                sportBool = true;
            }
            if (fileText.Contains("food"))
            {
                foodBool = true;
            }
            if (fileText.Contains("news"))
            {
                newsBool = true;
            }
            if (fileText.Contains("tech"))
            {
                techBool = true;
            }
            if (fileText.Contains("twitter"))
            {
                twitterBool = true;
            }
            if (fileText.Contains("reddit"))
            {
                redditBool = true;
            }

            //Brings up the loading screen, callonig methods to retrieve data from the various social media platforms.
            cover.Visibility = Visibility.Visible;
            loading.Visibility = Visibility.Visible;
            twitterRetrieval();
            redditRetrieval();
            getElements();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            StartGazeDeviceWatcher();
        }

        protected override void OnNavigatedFrom(NavigationEventArgs e)
        {
            StopGazeDeviceWatcher();
        }


        //Method to increase the current dwell count.
        //When dwell count increases past set period wedge functions can be called.
        private void TimerGaze_Tick(object sender, object e)
        {
            currentCount += dwellTime;
            if (currentCount >= 100)
            {
                //If first time method is called, wedges of menus are highlighted if a option is toggled.
                if (firstSetUP == "true")
                {
                    if (shareOptionbool)
                    {
                        socialMediaOptions.Pie.PieSlices[0].ClickInner();
                        totalOptionsSelected++;
                    }
                    if (commentOptionbool)
                    {
                        socialMediaOptions.Pie.PieSlices[1].ClickInner();
                        totalOptionsSelected++;
                    }
                    if (likeOptionbool)
                    {
                        socialMediaOptions.Pie.PieSlices[2].ClickInner();
                        totalOptionsSelected++;
                    }
                    if (postOptionbool)
                    {
                        socialMediaOptions.Pie.PieSlices[3].ClickInner();
                        totalOptionsSelected++;
                    }
                    if (twitterBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[0].ClickInner();
                    }
                    if (redditBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[1].ClickInner();
                    }
                    if (newsBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[2].ClickInner();
                    }
                    if (techBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[3].ClickInner();
                    }
                    if (sportBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[4].ClickInner();
                    }
                    if (foodBool)
                    {
                        filterOptionsMenu.Pie.PieSlices[5].ClickInner();
                    }
                    filterOptionsMenu.Pie.PieSlices[6].ClickInner();

                    changeOptions();
                    firstSetUP = "false";
                }

                //Checks the value of currentWedge.
                //The value of the wedge dictates the function to be called.
                //Before function is called a click is added for purposes of the user study.


                //Checking if the wedge is one of the react/ common features
                if (currentWedge == "wedge1")
                {
                    closeOpenMenu();
                    beginAction(wedge1Function);
                    numberOfClicks++;
                }
                else if (currentWedge == "wedge2")
                {
                    closeOpenMenu();
                    beginAction(wedge2Function);
                    numberOfClicks++;
                }
                else if (currentWedge == "wedge3")
                {
                    closeOpenMenu();
                    beginAction(wedge3Function);
                    numberOfClicks++;
                }
                else if (currentWedge == "wedge4")
                {
                    closeOpenMenu();
                    beginAction(wedge4Function);
                    numberOfClicks++;
                }

                //Checking if currentWedge is a scroll option.
                else if (currentWedge == "pageDown")
                {
                    currentCount = 0;
                    currentWedge = "none";
                    pageScrollDown();
                }
                else if (currentWedge == "pageUp")
                {
                    currentCount = 0;
                    currentWedge = "none";
                    pageScrollUp();
                }
                else if (currentWedge == "pageHome")
                {
                    currentCount = 0;
                    currentWedge = "none";
                    pageScrollHome();
                }

                //Checking if currentWedge is one of the react buttons.
                else if (currentWedge.Contains("button") && !anyMenuOpen)
                {
                    currentButton = currentWedge;

                    //Checks current button name which contains social media platform where the post is from.
                    if (currentButton.Contains("Twitter"))
                    {
                        currentMedium = "Twitter";
                    }
                    else if (currentButton.Contains("Reddit"))
                    {
                        currentMedium = "Reddit";
                    }
                    numberOfClicks++;

                    //Opens menu with the number of common features the user currently has selected.
                    if (totalOptionsSelected == 1)
                    {
                        radialMenu1Items.Visibility = Visibility.Visible;
                        anyMenuOpen = true;
                    }
                    else if (totalOptionsSelected == 2)
                    {
                        radialMenu2Items.Visibility = Visibility.Visible;
                        anyMenuOpen = true;
                    }
                    else if (totalOptionsSelected == 3)
                    {
                        radialMenu3Items.Visibility = Visibility.Visible;
                        anyMenuOpen = true;
                    }
                    else if (totalOptionsSelected == 4)
                    {
                        radialMenu4Items.Visibility = Visibility.Visible;
                        anyMenuOpen = true;
                    }
                    cover.Visibility = Visibility.Visible;
                    closeMenu.Visibility = Visibility.Visible;
                }

                //Checking if currentWedge is one of the common feature filter options.
                //If selected the option will be toggled on the menu with the boolean also changed.
                //Total options selected value altered. in order for correct react menu to appear.
                //CloseOpenMenu() and changeOptions() called if selected.
                else if (currentWedge == "shareOption")
                {
                    socialMediaOptions.Pie.PieSlices[0].ClickInner();
                    if (shareOptionbool)
                    {
                        shareOptionbool = false;
                        totalOptionsSelected--;
                    }
                    else
                    {
                        shareOptionbool = true;
                        totalOptionsSelected++;
                    }
                    closeOpenMenu();
                    changeOptions();
                    numberOfClicks++;
                }
                else if (currentWedge == "commentOption")
                {
                    socialMediaOptions.Pie.PieSlices[1].ClickInner();
                    if (commentOptionbool)
                    {
                        commentOptionbool = false;
                        totalOptionsSelected--;
                    }
                    else
                    {
                        commentOptionbool = true;
                        totalOptionsSelected++;
                    }
                    closeOpenMenu();
                    changeOptions();
                    numberOfClicks++;
                }
                else if (currentWedge == "likeOption")
                {
                    socialMediaOptions.Pie.PieSlices[2].ClickInner();
                    if (likeOptionbool)
                    {
                        likeOptionbool = false;
                        totalOptionsSelected--;
                    }
                    else
                    {
                        likeOptionbool = true;
                        totalOptionsSelected++;
                    }
                    closeOpenMenu();
                    changeOptions();
                    numberOfClicks++;
                }
                else if (currentWedge == "postOption")
                {
                    socialMediaOptions.Pie.PieSlices[3].ClickInner();
                    if (postOptionbool)
                    {
                        postOptionbool = false;
                        totalOptionsSelected--;
                    }
                    else
                    {
                        postOptionbool = true;
                        totalOptionsSelected++;
                    }
                    closeOpenMenu();
                    changeOptions();
                    numberOfClicks++;
                }

                //Opens base menus found on home page
                //For changing social media options and filter options.
                //For accessing dwell times change options and exit menu options.
                else if (currentWedge == "changeSocialActions")
                {
                    socialMediaOptions.Visibility = Visibility.Visible;
                    closeMenu.Visibility = Visibility.Visible;
                    cover.Visibility = Visibility.Visible;
                    anyMenuOpen = true;
                    numberOfClicks++;
                }
                else if (currentWedge == "changeFilterActions")
                {
                    filterOptionsMenu.Visibility = Visibility.Visible;
                    closeMenu.Visibility = Visibility.Visible;
                    cover.Visibility = Visibility.Visible;
                    anyMenuOpen = true;
                    numberOfClicks++;
                }
                else if (currentWedge == "changeDwellTimes")
                {
                    dwellOptionsMenu.Visibility = Visibility.Visible;
                    cover.Visibility = Visibility.Visible;
                    closeMenu.Visibility = Visibility.Visible;
                    anyMenuOpen = true;
                    numberOfClicks++;
                }
                else if (currentWedge == "exitChanges")
                {
                    otherOptionsMenu.Visibility = Visibility.Visible;
                    cover.Visibility = Visibility.Visible;
                    closeMenu.Visibility = Visibility.Visible;
                    anyMenuOpen = true;
                    numberOfClicks++;
                }


                //Chagnes value of dwelltime when option dwelled upon.
                else if (currentWedge == "slowDwell")
                {
                    closeOpenMenu();
                    dwellTime = 5;
                    numberOfClicks++;
                }
                else if (currentWedge == "midDwell")
                {
                    closeOpenMenu();
                    dwellTime = 8;
                    numberOfClicks++;
                }
                else if (currentWedge == "fastDwell")
                {
                    closeOpenMenu();
                    dwellTime = 10;
                    numberOfClicks++;
                }

                //Refreshed the news feed if option dwelled upon.
                else if (currentWedge == "refresh")
                {
                    closeOpenMenu();
                    refreshFeed();
                    numberOfClicks++;
                }

                //Calls the beginAction method which handles social media interactions.
                else if (currentWedge == "createPost")
                {
                    currentButton = "";
                    otherOptionsMenu.Visibility = Visibility.Collapsed;
                    closeMenu.Visibility = Visibility.Collapsed;
                    beginAction(currentWedge);
                    numberOfClicks++;
                }

                //Calls a method to post to a social media platform.
                else if (currentWedge == "postToTwitter" || currentWedge == "postToReddit" || currentWedge == "postToBoth")
                {
                    numberOfClicks++;
                    if (generalTextInput.Text != "")
                    {
                        postWithText(currentWedge);
                    }
                }

                //Calls a method to post to a social media platform.
                else if (currentWedge == "shareToTwitter" || currentWedge == "shareToReddit" || currentWedge == "shareToBoth")
                {
                    numberOfClicks++;
                    sharePost(currentWedge);
                }

                //Exits the program
                //Writes experimental data to file.
                //In order to write experimental data to file CoreApplication.Exit() is required to be commented.
                else if (currentWedge == "exit")
                {
                    if (firstExit)
                    {
                        numberOfClicks++;
                        Debug.WriteLine("25");
                        if (stageOfExperiment == 5 && experimentRunning)
                        {
                            sw.Stop();
                            Debug.WriteLine("Fifth Elapsed={0}", sw.Elapsed);
                            Debug.WriteLine("Total number of clicks is: " + numberOfClicks + 1);
                            double accuracyTotal = 2 / (numberOfClicks) * 100;
                            Debug.WriteLine("Accuracy of Task 5: " + accuracyTotal);
                            timeStamps[8] = (sw.Elapsed).ToString();
                            timeStamps[9] = accuracyTotal.ToString();
                            sw = new Stopwatch();
                            sw.Start();
                            numberOfClicks = 0;
                            stageOfExperiment++;
                            System.IO.File.WriteAllLines(@"H:\Documents\5_Year\MastersDiss\Saves\participant.txt", timeStamps);
                        }
                        firstExit = false;
                    }
                    CoreApplication.Exit();
                    Debug.WriteLine("experiment done");
                }

                //Calls function to write current settings to file.
                else if (currentWedge == "save")
                {
                    AddtoTextForFile();
                    closeOpenMenu();
                    numberOfClicks++;
                }

                //Calls function to write a comment on a post.
                else if (currentWedge == "submittingNewComment")
                {
                    numberOfClicks++;
                    postComment();
                }

                //When wedge is dwelled upon that filter option is toggled in the UI.
                //Boolean value is flipped to allow/stop those tagged items in the news feed.
                //Calls refresh function so newly filtered options change in news feed.
                else if (currentWedge == "twitter")
                {
                    closeOpenMenu();

                    twitterBool = !twitterBool;
                    filterOptionsMenu.Pie.PieSlices[0].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("28");
                }
                else if (currentWedge == "reddit")
                {
                    closeOpenMenu();
                    redditBool = !redditBool;
                    filterOptionsMenu.Pie.PieSlices[1].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("29");
                }
                else if (currentWedge == "tech")
                {
                    closeOpenMenu();
                    techBool = !techBool;
                    filterOptionsMenu.Pie.PieSlices[3].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("30");
                }
                else if (currentWedge == "sport")
                {
                    closeOpenMenu();
                    sportBool = !sportBool;
                    filterOptionsMenu.Pie.PieSlices[4].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("31");
                }
                else if (currentWedge == "food")
                {
                    closeOpenMenu();
                    foodBool = !foodBool;
                    filterOptionsMenu.Pie.PieSlices[5].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("32");
                }
                else if (currentWedge == "news")
                {
                    closeOpenMenu();
                    newsBool = !newsBool;
                    filterOptionsMenu.Pie.PieSlices[2].ClickInner();
                    refreshFeed();
                    numberOfClicks++;
                    Debug.WriteLine("33");
                }

                //Resets all filter options so that the itesm appear in the central feed and are toggled on.
                else if (currentWedge == "resetOptions")
                {
                    closeOpenMenu();

                    if (!twitterBool)
                    {
                        twitterBool = true;
                        filterOptionsMenu.Pie.PieSlices[0].ClickInner();
                    }
                    if (!redditBool)
                    {
                        redditBool = true;
                        filterOptionsMenu.Pie.PieSlices[1].ClickInner();
                    }
                    if (!sportBool)
                    {
                        sportBool = true;
                        filterOptionsMenu.Pie.PieSlices[4].ClickInner();
                    }
                    if (!techBool)
                    {
                        techBool = true;
                        filterOptionsMenu.Pie.PieSlices[3].ClickInner();
                    }
                    if (!newsBool)
                    {
                        newsBool = true;
                        filterOptionsMenu.Pie.PieSlices[2].ClickInner();
                    }
                    if (!foodBool)
                    {
                        foodBool = true;
                        filterOptionsMenu.Pie.PieSlices[5].ClickInner();
                    }
                    if (!uniBool)
                    {
                        uniBool = true;
                    }
                    refreshFeed();
                    numberOfClicks++;
                }

                //Calls function to close any open menus.
                else if (currentWedge == "closeOpenMenu")
                {
                    closeOpenMenu();
                    numberOfClicks++;
                }
            }
        }

        //This method writes the current settings of the system to the external save file.
        private void AddtoTextForFile()
        {
            textForFile = "";
            if (dwellTime == 5)
            {
                textForFile += "slowDwell ";
            }
            else if (dwellTime == 8)
            {
                textForFile += "mediumDwell ";
            }
            else if (dwellTime == 10)
            {
                textForFile += "fastDwell ";
            }

            if (likeOptionbool)
            {
                textForFile += "like ";
            }
            if (shareOptionbool)
            {
                textForFile += "share ";
            }
            if (commentOptionbool)
            {
                textForFile += "comment ";
            }
            if (postOptionbool)
            {
                textForFile += "post ";
            }
            if (twitterBool)
            {
                textForFile += "twitter ";
            }
            if (redditBool)
            {
                textForFile += "reddit ";
            }
            if (sportBool)
            {
                textForFile += "sport ";
            }
            if (newsBool)
            {
                textForFile += "news ";
            }
            if (techBool)
            {
                textForFile += "tech ";
            }
            if (foodBool)
            {
                textForFile += "food ";
            }

            //Writes to file in path below.
            System.IO.File.WriteAllText(@"H:\Documents\5_Year\MastersDiss\Saves\save.txt", textForFile);
        }

        //Method to refresh the news feed.
        //Async method to allow UI elements to align with code running.
        async void refreshFeed()
        {
            await Task.Delay(1000);
            //Clears listview, making central feed empty.
            listView1.Items.Clear();
            cover.Visibility = Visibility.Visible;
            loading.Visibility = Visibility.Visible;

            //Retrieves data from Twitter and Reddit.
            twitterRetrieval();
            redditRetrieval();
        }


        //Method to get all the elements in the central feed.
        //Calculates and adds the position of the react buttons in the listview.
        private void getElements()
        {
            //Clears the old positions of the buttons in the listview.
            buttonPosList.Clear();
            buttonRealPostList.Clear();
            buttonNameList.Clear();
            buttonRealNameList.Clear();

            //Gets scrollviewer object to find elements inside the listview from GetScrollViewer() function.
            ScrollViewer scrollViewer = GetScrollViewer(listView1);

            //Loops through each element in the listview and if the element is visible on the screen it is added
            //to the list of visible buttons.
            foreach (var item in listView1.Items)
            {
                var container = listView1.ContainerFromItem(item);
                FrameworkElement element = container as FrameworkElement;
                if (element != null)
                {
                    newsEntry temp = (newsEntry)item;
                    buttonNameList.Add(temp.buttonName);
                    var transform = element.TransformToVisual(Window.Current.Content);
                    Point positionInScrollViewer = transform.TransformPoint(new Point(0, 0));
                    double[] temp1 = new double[2];
                    double[] temp2 = new double[2];
                    temp1[0] = positionInScrollViewer.X;
                    temp1[1] = positionInScrollViewer.Y;
                    temp2[0] = positionInScrollViewer.X;
                    temp2[1] = positionInScrollViewer.Y + 400;
                    if (temp2[1] >= 50 && temp2[1] <= 850)
                    {
                        buttonRealPostList.Add(temp2);
                        buttonRealNameList.Add(temp.buttonName);
                    }
                    buttonPosList.Add(temp1);
                }
            }
        }

        //This function returns ScrollViewer object using VisualTreeHelper.
        public static ScrollViewer GetScrollViewer(DependencyObject depObj)
        {
            var obj = depObj as ScrollViewer;
            if (obj != null) return obj;

            for (int i = 0; i < VisualTreeHelper.GetChildrenCount(depObj); i++)
            {
                var child = VisualTreeHelper.GetChild(depObj, i);

                var result = GetScrollViewer(child);
                if (result != null) return result;
            }
            return null;
        }

        //This function is called whenever a movement is detected in a user's gaze by the eye tracker.
        private void GazeMoved(GazeInputSourcePreview sender, GazeMovedPreviewEventArgs args)
        {
            //If there is a present gaze, then the current gaze coordinate is recorded. 
            if (args.CurrentPoint.EyeGazePosition != null)
            {
                double gazePointX = args.CurrentPoint.EyeGazePosition.Value.X;
                double gazePointY = args.CurrentPoint.EyeGazePosition.Value.Y;

                Point gazePoint = new Point(gazePointX, gazePointY);

                //This method call checks if the gaze points are over a dwellable selection.
                DoesElementContainPoint(
                    gazePoint);
                args.Handled = true;
            }
        }

        //This method checks if the user is dwelling on a menu or option, setting the currentWedge variable to the item the user is staring at.
        private bool DoesElementContainPoint(
           Point gazePoint)
        {
            //Get the current screen position of the mouse. Can be used to testing purposes.
            var pointerPosition = Windows.UI.Core.CoreWindow.GetForCurrentThread().PointerPosition;
            var Mousex = pointerPosition.X - Window.Current.Bounds.X;
            var Mousey = pointerPosition.Y - Window.Current.Bounds.Y;

            //Filters the gaze of the eye tracker so the gaze position is calculated from the centre of the screen.
            var filteredGazeX = (gazePoint.X - (radialMenuX + (radialMenu4Items.Diameter / 2)));
            var filteredGazeY = (gazePoint.Y - (radialMenuY + (radialMenu4Items.Diameter / 2)));

            //Calculates the radius of the radial menus.
            var radius = radialMenu4Items.Diameter / 2;

            //Calculates the current angle of the gaze point.
            //Calculates the current distance of the gze points from the centre of the menu .
            var currentAngle = Math.Atan(filteredGazeY / filteredGazeX);
            var currentRadius = Math.Sqrt((filteredGazeX * filteredGazeX) + (filteredGazeY * filteredGazeY));
            currentAngle = (180 / Math.PI) * currentAngle;

            //nameInput.Text = "Mouse X: " + Mousex + " Mouse Y: " + Mousey;
            
            //If all four react options are visible check for the the gaze being inside one of the wedges.
            if (radialMenu4Items.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 90)
                    {
                        currentWedge = "wedge1";
                        goto timer;
                    }
                    else if (currentAngle >= 91 && currentAngle <= 180)
                    {
                        currentWedge = "wedge2";
                        goto timer;
                    }
                    else if (currentAngle >= 181 && currentAngle <= 270)
                    {
                        currentWedge = "wedge3";
                        goto timer;
                    }
                    else if (currentAngle >= 271 && currentAngle <= 360)
                    {
                        currentWedge = "wedge4";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }


            }
            //If three react options are visible check for the the gaze being inside one of the wedges.
            else if (radialMenu3Items.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 120)
                    {
                        currentWedge = "wedge1";
                        goto timer;
                    }
                    else if (currentAngle >= 121 && currentAngle <= 240)
                    {
                        currentWedge = "wedge2";
                        goto timer;
                    }
                    else if (currentAngle >= 241 && currentAngle <= 360)
                    {
                        currentWedge = "wedge3";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }
            //If two react options are visible check for the the gaze being inside one of the wedges.
            else if (radialMenu2Items.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 180)
                    {
                        currentWedge = "wedge1";
                        goto timer;

                    }
                    else if (currentAngle >= 181 && currentAngle <= 360)
                    {
                        currentWedge = "wedge2";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }


            }
            //If one react option is visible check for the the gaze being inside one of the wedges.
            else if (radialMenu1Items.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }
                if (currentRadius < radius)
                {
                    if (currentAngle >= 1 && currentAngle <= 360)
                    {
                        currentWedge = "wedge1";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }
                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }

            //If social media options menu is open, checks if the gaze is placed on any of the sections.
            else if (socialMediaOptions.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 90)
                    {
                        currentWedge = "shareOption";
                        goto timer;
                    }
                    else if (currentAngle >= 91 && currentAngle <= 180)
                    {
                        currentWedge = "commentOption";
                        goto timer;
                    }
                    else if (currentAngle >= 181 && currentAngle <= 270)
                    {
                        currentWedge = "likeOption";
                        goto timer;
                    }
                    else if (currentAngle >= 271 && currentAngle <= 360)
                    {
                        currentWedge = "postOption";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }

            //If dwell options menu is open, checks if the gaze is placed on any of the sections.
            else if (dwellOptionsMenu.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;

                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 120)
                    {
                        currentWedge = "slowDwell";
                        goto timer;
                    }
                    else if (currentAngle >= 121 && currentAngle <= 240)
                    {
                        currentWedge = "midDwell";
                        goto timer;
                    }
                    else if (currentAngle >= 241 && currentAngle <= 360)
                    {
                        currentWedge = "fastDwell";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }

            //If options menu is open, checks if the gaze is placed on any of the sections.
            else if (otherOptionsMenu.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;

                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }

                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 90)
                    {
                        currentWedge = "refresh";
                        goto timer;
                    }
                    else if (currentAngle >= 91 && currentAngle <= 180)
                    {
                        currentWedge = "createPost";
                        goto timer;
                    }
                    else if (currentAngle >= 181 && currentAngle <= 270)
                    {
                        currentWedge = "exit";
                        goto timer;
                    }
                    else if (currentAngle > 271 && currentAngle <= 360)
                    {
                        currentWedge = "save";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }

                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }
            else if (postToBoth.Visibility == Visibility.Visible)
            {
                if (gazePoint.X > 0 && gazePoint.X < 250)
                {
                    if (gazePoint.Y > 0 && gazePoint.Y < 250)
                    {
                        currentWedge = "closeOpenMenu";
                        goto timer;
                    }
                }
                else
                if (gazePoint.Y > 377 && gazePoint.Y < 627)
                {
                    if (gazePoint.X >= 300 && gazePoint.X < 550)
                    {
                        currentWedge = "postToTwitter";
                        goto timer;
                    }
                    else if (gazePoint.X > 820 && gazePoint.X < 1070)
                    {
                        currentWedge = "postToReddit";
                        goto timer;
                    }
                    else if (gazePoint.X > 1310 && gazePoint.X < 1560)
                    {
                        currentWedge = "postToBoth";
                        goto timer;
                    }
                    else
                    {
                        currentWedge = "";
                    }
                }
                else
                {
                    currentWedge = "";
                }
            }
            else if (shareToReddit.Visibility == Visibility.Visible)
            {
                if (gazePoint.Y > 377 && gazePoint.Y < 627)
                {
                    if (gazePoint.X >= 300 && gazePoint.X < 550)
                    {
                        currentWedge = "shareToTwitter";
                        goto timer;
                    }
                    else if (gazePoint.X > 820 && gazePoint.X < 1070)
                    {
                        currentWedge = "shareToReddit";
                        goto timer;
                    }
                    else if (gazePoint.X > 1310 && gazePoint.X < 1560)
                    {
                        currentWedge = "shareToBoth";
                        goto timer;
                    }
                    else
                    {
                        currentWedge = "";
                    }
                }
                else
                {
                    currentWedge = "";
                }
                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }
            else if (submitComment.Visibility == Visibility.Visible)
            {
                if (gazePoint.X > 459 && gazePoint.X < 1459)
                {
                    if (gazePoint.Y > 500 && gazePoint.Y < 1000)
                    {
                        currentWedge = "submittingNewComment";
                        goto timer;
                    }
                    else
                    {
                        currentWedge = "";
                    }
                }
                else
                {
                    currentWedge = "";
                }
                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }

            //If filter options menu is open, checks if the gaze is placed on any of the sections.
            else if (filterOptionsMenu.Visibility == Visibility.Visible)
            {
                if (filteredGazeX > 0 && filteredGazeY < 0)
                {
                    currentAngle += 90;
                    section = "1";
                }
                else if (filteredGazeX > 0 && filteredGazeY > 0)
                {
                    currentAngle += 90;
                    section = "2";
                }
                else if (filteredGazeX < 0 && filteredGazeY > 0)
                {
                    section = "3";
                    currentAngle += 270;
                }
                else if (filteredGazeX < 0 && filteredGazeY < 0)
                {
                    currentAngle += 270;
                    section = "4";
                }
                if (currentRadius < radius)
                {
                    if (currentAngle >= 0 && currentAngle <= 51)
                    {
                        currentWedge = "twitter";
                        goto timer;
                    }
                    else if (currentAngle >= 52 && currentAngle <= 102)
                    {
                        currentWedge = "reddit";
                        goto timer;
                    }
                    else if (currentAngle >= 103 && currentAngle <= 154)
                    {
                        currentWedge = "news";
                        goto timer;
                    }
                    else if (currentAngle >= 155 && currentAngle <= 206)
                    {
                        currentWedge = "tech";
                        goto timer;
                    }
                    else if (currentAngle >= 207 && currentAngle <= 258)
                    {
                        currentWedge = "sport";
                        goto timer;
                    }
                    else if (currentAngle >= 259 && currentAngle <= 310)
                    {
                        currentWedge = "food";
                        goto timer;
                    }
                    else if (currentAngle >= 311 && currentAngle <= 360)
                    {
                        currentWedge = "resetOptions";
                        goto timer;
                    }
                }
                else
                {
                    currentWedge = "none";
                }
                if (closeMenu.Visibility == Visibility.Visible)
                {
                    if (gazePoint.X > 0 && gazePoint.X < 250)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 250)
                        {
                            currentWedge = "closeOpenMenu";
                            goto timer;
                        }
                    }
                }
            }
            else
            {
                //If no menu is open, i.e the applicaiton is on the home area, checks for scrolling and base menu selections.
                if (!anyMenuOpen && closeMenu.Visibility == Visibility.Collapsed)
                {
                    //nameInput.Text = "X :" + Mousex + " Y:" + Mousey;
                    if (gazePoint.Y >= 850 && gazePoint.Y <= 1000)
                    {
                        if (gazePoint.X >= 460 && gazePoint.X <= 610)
                        {
                            currentWedge = "pageDown";
                            goto timer;
                        }
                        else if (gazePoint.X >= 895 && gazePoint.X <= 1045)
                        {
                            currentWedge = "pageUp";
                            goto timer;
                        }
                        else if (gazePoint.X >= 1310 && gazePoint.X <= 1460)
                        {
                            currentWedge = "pageHome";
                            goto timer;
                        }
                    }
                    else if (gazePoint.X > 0 && gazePoint.X < 210)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 500)
                        {
                            currentWedge = "changeSocialActions";
                            goto timer;
                        }
                        else if (gazePoint.Y > 500 && gazePoint.Y < 1000)
                        {
                            currentWedge = "changeFilterActions";
                            goto timer;
                        }
                    }
                    else if (gazePoint.X > 1710 && gazePoint.X < 1920)
                    {
                        if (gazePoint.Y > 0 && gazePoint.Y < 500)
                        {
                            currentWedge = "changeDwellTimes";
                            goto timer;
                        }
                        else if (gazePoint.Y > 500 && gazePoint.Y < 1000)
                        {
                            currentWedge = "exitChanges";
                            goto timer;
                        }
                    }

                    //Set currentWedge to none if user is not dwelling on a dwellable option.
                    else
                    {
                        currentWedge = "none";
                    }
                    if (gazePoint.X >= 460 && gazePoint.X <= 1460)
                    {
                        int counter5 = 0;
                        foreach (var pos in buttonRealPostList)
                        {
                            if (gazePoint.Y >= pos[1] && gazePoint.Y <= pos[1] + 100)
                            {
                                currentWedge = buttonRealNameList[counter5];
                            }
                            counter5++;
                        }
                    }
                }
                else
                {
                    if (closeMenu.Visibility == Visibility.Visible)
                    {
                        if (gazePoint.X > 0 && gazePoint.X < 250)
                        {
                            if (gazePoint.Y > 0 && gazePoint.Y < 250)
                            {
                                currentWedge = "closeOpenMenu";
                                goto timer;

                            }
                        }
                    }
                }
            }

        //Area for checks to break too. 
        //If the currentWedge was the same as the previous wedge then the time is started if not already started.
        //If currentwedge and previous wedge were the same then return true.
        timer: if (prevWedge == currentWedge && prevWedge != "none")
            {
                if (!timerStarted)
                {
                    timerGaze.Start();
                    timerStarted = true;
                }
                return true;
            }

            //Set prevwedge and reset dwell counters and timer, as the user is no longer dwelling on the same area.
            prevWedge = currentWedge;
            currentCount = 0;
            timerGaze.Stop();
            timerStarted = false;
            return false;
        }

        //Add events when eye tracker is detected.
        private void StartGazeDeviceWatcher()
        {
            if (gazeDeviceWatcher == null)
            {
                gazeDeviceWatcher = GazeInputSourcePreview.CreateWatcher();
                gazeDeviceWatcher.Added += this.DeviceAdded;
                gazeDeviceWatcher.Updated += this.DeviceUpdated;
                gazeDeviceWatcher.Removed += this.DeviceRemoved;
                gazeDeviceWatcher.Start();
            }
        }

        //Add events when eye tracker is detected.
        private void StopGazeDeviceWatcher()
        {
            if (gazeDeviceWatcher != null)
            {
                gazeDeviceWatcher.Stop();
                gazeDeviceWatcher.Added -= this.DeviceAdded;
                gazeDeviceWatcher.Updated -= this.DeviceUpdated;
                gazeDeviceWatcher.Removed -= this.DeviceRemoved;
                gazeDeviceWatcher = null;
            }
        }

        //Method runs when an eye tracker is detected by the system.
        private void DeviceAdded(GazeDeviceWatcherPreview source,
           GazeDeviceWatcherAddedPreviewEventArgs args)
        {
            TryEnableGazeTrackingAsync(args.Device);
        }

        //Method runs when eye tracking device is updated.
        private void DeviceUpdated(GazeDeviceWatcherPreview source,
         GazeDeviceWatcherUpdatedPreviewEventArgs args)
        {
            TryEnableGazeTrackingAsync(args.Device);
        }

        //Method runs when an eye tracker detected by the system is removed.
        private void DeviceRemoved(GazeDeviceWatcherPreview source,
          GazeDeviceWatcherRemovedPreviewEventArgs args)
        {
            //can be used to remove any device
        }


        //This method runs on eye tracker detection.
        //Sets up timing loop for checking eye tracker gaze events.
        private async void TryEnableGazeTrackingAsync(GazeDevicePreview gazeDevice)

        {
            if (IsSupportedDevice(gazeDevice))
            {
                timerGaze.Interval = new TimeSpan(0, 0, 0, 0, 5);
                timerGaze.Tick += TimerGaze_Tick;
                gazeInputSource = GazeInputSourcePreview.GetForCurrentView();
                gazeInputSource.GazeMoved += GazeMoved;
            }
            else if (gazeDevice.ConfigurationState ==
                     GazeDeviceConfigurationStatePreview.UserCalibrationNeeded ||
                     gazeDevice.ConfigurationState ==
                     GazeDeviceConfigurationStatePreview.ScreenSetupNeeded)
            {
                System.Diagnostics.Debug.WriteLine(
                    "Your device needs to calibrate. Please wait for it to finish.");
                await gazeDevice.RequestCalibrationAsync();
            }
            else if (gazeDevice.ConfigurationState ==
                GazeDeviceConfigurationStatePreview.Configuring)
            {
                System.Diagnostics.Debug.WriteLine(
                    "Your device is being configured. Please wait for it to finish");
            }
            else if (gazeDevice.ConfigurationState == GazeDeviceConfigurationStatePreview.Unknown)
            {
                System.Diagnostics.Debug.WriteLine(
                    "Your device is not ready. Please set up your device or reconfigure it.");
            }
        }

        //This method checks if the eye tracker is supported by UWP.
        private bool IsSupportedDevice(GazeDevicePreview gazeDevice)
        {
            return (gazeDevice.CanTrackEyes &&
                     gazeDevice.ConfigurationState ==
                     GazeDeviceConfigurationStatePreview.Ready);
        }

        //This method is used for testing purposes and can mock items into the news feed.
        async void setUp()
        {
            newsEntry entry = createObject("Reddit", "Sport", "yhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouyhehfeouzzzz", "button1", "w");
            await Task.Delay(500);
            listView1.Items.Add(entry);
            newsEntry entry1 = createObject("Twitter", "Tech", "ehrtnrt", "button2", "w");
            await Task.Delay(500);
            listView1.Items.Add(entry1);
            newsEntry entry2 = createObject("Twitter", "Friends", "egesw", "button3", "w");
            await Task.Delay(500);
            listView1.Items.Add(entry2);
            newsEntry entry3 = createObject("Reddit", "News", "yhefefhfeou", "button4", "w");
            await Task.Delay(500);
            listView1.Items.Add(entry3);
            newsEntry entry4 = createObject("Reddit", "News", "FOUR", "button46", "w");
            await Task.Delay(500);
            listView1.Items.Add(entry4);
            getElements();
        }

        //This method is used to retrieve the feed data from Reddit.
        async void redditRetrieval()
        {
            //Define list to store reddit posts from the users account.
            List<newsEntry> redditItems = new List<newsEntry>();

            //Create reddit API object, using, application id, secret key and two authorisation codes.
            reddit = new RedditAPI("SocialEyes", "255248032387-VZntSjNpMGFonnweMmNBlwi1yKg", "ChPizj09KlHQnxkQd3lHT -WMtgo", "255248032387-L10pBXBbjJ_LN0tKbTJZ0FCuZJI");

            //Retrieve objects from subscribed reddit subreddits on attached account.
            var obj = reddit.Account.MySubscribedSubreddits(1);

            //var obj = reddit.Subreddit("r/SocialEyesTest");
            // reddit.Account.MySubscribedSubreddits

            if (redditBool)
            {
                for (int i = 0; i < 1; i++)
                {

                    var sub = reddit.Subreddit(obj[i].Name);

                    //var sub = obj;

                    tempPosts.Clear();
                    //tempPosts = (sub.Posts.GetBest());

                    //Retrieve a users 'top posts' according to reddit.
                    tempPosts = (sub.Posts.GetTop());


                    topPosts.AddRange(tempPosts);


                    //For all the posts retrieved from reddit, assign a tag to the post.
                    //If the tag is not currently filtered out then add to the central feed.
                    foreach (var posts in tempPosts)
                    {
                        if (posts is Reddit.Controllers.SelfPost)
                        {
                            String tag = assignRedditTag(posts, sub);

                            if (checkTag(tag, posts.Listing.SelfText))
                            {
                                String buttonName = "buttonReddit" + buttonCounter;
                                newsEntry entry1 = createObject("Reddit", tag, posts.Listing.SelfText, buttonName, (posts.Id).ToString());
                                if (posts.Listing.SelfText != "")
                                {
                                    redditItems.Add(entry1);
                                    buttonCounter++;
                                }

                            }
                        }
                    }
                }
                foreach (var item in redditItems)
                {
                    await Task.Delay(500);
                    listView1.Items.Add(item);
                }
            }
        }

        //This method is used to retrieve the feed data from Twitter.
        async void twitterRetrieval()
        {
            //Attach users Twitter account to the application
            TweetinviConfig.CurrentThreadSettings.TweetMode = TweetMode.Extended;
            Auth.SetUserCredentials("5iv0oTsBpa5SoRUNNghoq8l92", "a2IvdhNfzS2MCuTEi4UWev3UkLxfc1PuTPKnEKPpbFSO9J0BWq", "1097445575803449345-RLKAnPxSnl2AIrz1nhAg1Erm3eecTy", "1qVgSjAMBXLmJj0MioNFhTF6I8aeW8ft560DBRKSbO0zZ");
            var user = Tweetinvi.User.GetAuthenticatedUser();

            //Retrieves a set number of tweets from the user's timeline.
            timelineTweets = Timeline.GetHomeTimeline(40);

            if (twitterBool)
            {
                //Create list to store twitter posts retrieved.
                List<newsEntry> twitterItems = new List<newsEntry>();

                buttonCounter = 0;
                //For all the posts retrieved from twitter, assign a tag to the post.
                //If the tag is not currently filtered out then add to the central feed.
                foreach (var timelineTweet in timelineTweets)
                {
                    if (timelineTweet.IsRetweet == false)
                    {
                    String tag = assignTag(timelineTweet);
                    if (checkTag(tag, timelineTweet.FullText))
                    {

                        String buttonName = "buttonTwitter" + buttonCounter;
                        newsEntry entry1 = createObject("Twitter", tag, timelineTweet.FullText, buttonName, (timelineTweet.Id).ToString());
                        twitterItems.Add(entry1);
                        Debug.WriteLine(timelineTweet.FullText);
                        buttonCounter++;
                        var success = Tweet.FavoriteTweet(timelineTweet);
                    }

                    }

                }
                double twitterCount = 0;
                //Calculates the amount the program has loaded when creating centrals feeds.
                foreach (var item in twitterItems)
                {
                    twitterCount++;
                    double load = Math.Round((twitterCount / timelineTweets.Count() * 100 * (100 / timelineTweets.Count())) / 2);
                    loading.Text = "Loading: " + load + "%";
                    listView1.Items.Add(item);
                    await Task.Delay(500);
                }
                loading.Visibility = Visibility.Collapsed;
                cover.Visibility = Visibility.Collapsed;
                sw = new Stopwatch();
                sw.Start();
                getElements();
            }
        }

        //This method creates a newsEntry object, from the information retrieved from a social media post.
        private newsEntry createObject(string socialMedia, string newsType, string newsText, string buttonName, string id)
        {
            //Calculates the number of words in the post, in order to define text size.
            int a = 0, myWord = 1;
            while (a < newsText.Length - 1)
            {
                if (newsText[a] == ' ' || newsText[a] == '\n' || newsText[a] == '\t')
                {
                    myWord++;
                }
                a++;
            }

            //Creates blank newsEntry object, then populating the object with post information.
            newsEntry newEntry = new newsEntry();
            newEntry.socialMediaType = socialMedia;
            newEntry.newsItemType = newsType;
            newEntry.newsText = newsText;
            newEntry.buttonName = buttonName;
            newEntry.id = id;

            //Define font size of number of words previously calculated.
            if (myWord > 60 && myWord < 80)
            {
                newEntry.fontSize = 14;
            }
            else if (myWord > 80)
            {
                string shortText = newsText.Substring(0, newsText.IndexOf(" ", 80));
                shortText = shortText + " ....";
                newEntry.newsText = shortText;
                newEntry.fontSize = 24;
            }
            else
            {
                newEntry.fontSize = 24;
            }
            return newEntry;

        }

        //This method scrolls the news feed down by one item.
        async void pageScrollDown()
        {
            if (count <= listView1.Items.Count)
            {
                count++;
                listView1.ScrollIntoView(listView1.Items[count]);
                var item = listView1.Items[0];
                await Task.Delay(500);
                getElements();
            }
        }

        //This method scrolls the news feed up by one item.
        async void pageScrollUp()
        {
            if (count > 0)
            {
                count--;
                listView1.ScrollIntoView(listView1.Items[count]);
                await Task.Delay(500);
                getElements();
            }
        }

        //This method scrolls the news feed back to the first item.
        async void pageScrollHome()
        {
            count = 0;
            listView1.ScrollIntoView(listView1.Items[count]);
            await Task.Delay(500);
            getElements();
        }

        //This method changes the options of the system. It assigns the labels and icons to the wedges in the react menu.
        public void changeOptions()
        {
            //Lists of the options that will appear in the reacat menu.
            List<String> optionsBeingSet = new List<String>();
            List<String> optionsBeingSetIcon = new List<String>();
            if (likeOptionbool)
            {
                optionsBeingSet.Add("Like");
                optionsBeingSetIcon.Add("👍");
            }
            if (shareOptionbool)
            {
                optionsBeingSet.Add("Share");
                optionsBeingSetIcon.Add("📤");
            }
            if (commentOptionbool)
            {
                optionsBeingSet.Add("Comment");
                optionsBeingSetIcon.Add("✍️");
            }
            if (postOptionbool)
            {
                optionsBeingSet.Add("Post");
                optionsBeingSetIcon.Add("✉️");
            }

            wedge1Function = "";
            wedge2Function = "";
            wedge3Function = "";
            wedge4Function = "";
            for (int x = 0; x < totalOptionsSelected; x++)
            {
                if (x == 0)
                {
                    wedge1Function = optionsBeingSet[x];
                }
                if (x == 1)
                {
                    wedge2Function = optionsBeingSet[x];
                }
                if (x == 2)
                {
                    wedge3Function = optionsBeingSet[x];
                }
                if (x == 3)
                {
                    wedge4Function = optionsBeingSet[x];
                }
            }

            //Sets the wedges depending on the number of options being set.
            if (totalOptionsSelected == 1)
            {
                radialMenu1Items.Pie.PieSlices[0].Label = optionsBeingSet[0];
                radialMenu1Items.Pie.PieSlices[0].Icon = optionsBeingSetIcon[0];
            }
            else if (totalOptionsSelected == 2)
            {
                radialMenu2Items.Pie.PieSlices[0].Label = optionsBeingSet[0];
                radialMenu2Items.Pie.PieSlices[1].Label = optionsBeingSet[1];
                radialMenu2Items.Pie.PieSlices[0].Icon = optionsBeingSetIcon[0];
                radialMenu2Items.Pie.PieSlices[1].Icon = optionsBeingSetIcon[1];
            }
            else if (totalOptionsSelected == 3)
            {
                radialMenu3Items.Pie.PieSlices[0].Label = optionsBeingSet[0];
                radialMenu3Items.Pie.PieSlices[1].Label = optionsBeingSet[1];
                radialMenu3Items.Pie.PieSlices[2].Label = optionsBeingSet[2];
                radialMenu3Items.Pie.PieSlices[0].Icon = optionsBeingSetIcon[0];
                radialMenu3Items.Pie.PieSlices[1].Icon = optionsBeingSetIcon[1];
                radialMenu3Items.Pie.PieSlices[2].Icon = optionsBeingSetIcon[2];
            }
            else if (totalOptionsSelected == 4)
            {
                radialMenu4Items.Pie.PieSlices[0].Label = optionsBeingSet[0];
                radialMenu4Items.Pie.PieSlices[1].Label = optionsBeingSet[1];
                radialMenu4Items.Pie.PieSlices[2].Label = optionsBeingSet[2];
                radialMenu4Items.Pie.PieSlices[3].Label = optionsBeingSet[3];
                radialMenu4Items.Pie.PieSlices[0].Icon = optionsBeingSetIcon[0];
                radialMenu4Items.Pie.PieSlices[1].Icon = optionsBeingSetIcon[1];
                radialMenu4Items.Pie.PieSlices[2].Icon = optionsBeingSetIcon[2];
                radialMenu4Items.Pie.PieSlices[3].Icon = optionsBeingSetIcon[3];

            }
        }

        //This method closes all menus that are currently open.
        //Is mostly called after the user selects an option in an open menu.
        //If a menu is visible, then it is collapsed.
        //The cover shown behind menus is collapsed, with the canpost and canshare objects being reset.
        public void closeOpenMenu()
        {

            if (radialMenu4Items.Visibility == Visibility.Visible)
            {
                radialMenu4Items.Visibility = Visibility.Collapsed;
            }
            else if (radialMenu3Items.Visibility == Visibility.Visible)
            {
                radialMenu3Items.Visibility = Visibility.Collapsed;
            }
            else if (radialMenu2Items.Visibility == Visibility.Visible)
            {
                radialMenu2Items.Visibility = Visibility.Collapsed;
            }
            else if (radialMenu1Items.Visibility == Visibility.Visible)
            {
                radialMenu1Items.Visibility = Visibility.Collapsed;
            }
            else if (socialMediaOptions.Visibility == Visibility.Visible)
            {
                socialMediaOptions.Visibility = Visibility.Collapsed;
            }
            else if (filterOptionsMenu.Visibility == Visibility.Visible)
            {
                filterOptionsMenu.Visibility = Visibility.Collapsed;
            }
            else if (dwellOptionsMenu.Visibility == Visibility.Visible)
            {
                dwellOptionsMenu.Visibility = Visibility.Collapsed;
            }
            else if (otherOptionsMenu.Visibility == Visibility.Visible)
            {
                otherOptionsMenu.Visibility = Visibility.Collapsed;
            }
            closeMenu.Visibility = Visibility.Collapsed;
            cover.Visibility = Visibility.Collapsed;
            generalTextInput.Visibility = Visibility.Collapsed;
            seeMorePost.Visibility = Visibility.Collapsed;
            postToBoth.Visibility = Visibility.Collapsed;
            postToReddit.Visibility = Visibility.Collapsed;
            postToTwitter.Visibility = Visibility.Collapsed;
            submitComment.Visibility = Visibility.Collapsed;
            shareToBoth.Visibility = Visibility.Collapsed;
            shareToReddit.Visibility = Visibility.Collapsed;
            shareToTwitter.Visibility = Visibility.Collapsed;
            anyMenuOpen = false;
            canPost = true;
            canShare = true;
        }

        //This method handles all actions that are called for handling social media requests.
        async void beginAction(String wedgeFunction)
        {
            //Finds the id of the post being reacted too.
            await Task.Delay(10);
            String idToUse = "";
            for (int x = 0; x < listView1.Items.Count; x++)
            {
                newsEntry entry = (newsEntry)listView1.Items[x];
                if (entry.buttonName == currentButton)
                {
                    idToUse = entry.id;
                }
            }

            //If the current post is a Twitter post, then the post is identified.
            if (currentButton.Contains("Twitter"))
            {
                foreach (var item in timelineTweets)
                {
                    if (item.Id.ToString() == idToUse)
                    {
                        tweetToUse = item;
                        //If the current function is too like a post then the Twitter favourite function is called.
                        //If the post is already liked then the post is unliked.
                        if (wedgeFunction == "Like")
                        {
                            if (tweetToUse.Favorited)
                            {
                                var success = Tweet.UnFavoriteTweet(tweetToUse);
                            }
                            else
                            {
                                var success = Tweet.FavoriteTweet(tweetToUse);
                                numberofExperimentalLikes++;
                                //Timing data for use study tasks.
                                if (stageOfExperiment == 4 && experimentRunning && numberofExperimentalLikes == 2)
                                {
                                    sw.Stop();

                                    Debug.WriteLine("Fourth Elapsed={0}", sw.Elapsed);
                                    Debug.WriteLine("Total number of clicks is: " + numberOfClicks);
                                    double accuracyTotal = 4 / numberOfClicks * 100;
                                    Debug.WriteLine("Accuracy of Task 4: " + accuracyTotal);
                                    timeStamps[6] = (sw.Elapsed).ToString();
                                    timeStamps[7] = accuracyTotal.ToString();
                                    await Task.Delay(50);
                                    numberOfClicks = 0;
                                    stageOfExperiment++;
                                    sw = new Stopwatch();
                                    sw.Start();
                                }
                            }
                        }
                        //If current function is comment, then comment menu is made visible.
                        else if (wedgeFunction == "Comment")
                        {
                            generalTextInput.Visibility = Visibility.Visible;
                            submitComment.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                            cover.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                        }

                        //If current function is share and the user can share then share menu is made visible.
                        else if (wedgeFunction == "Share" && canShare)
                        {
                            canShare = false;
                            shareToReddit.Visibility = Visibility.Visible;
                            shareToTwitter.Visibility = Visibility.Visible;
                            shareToBoth.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                            cover.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                        }
                        //If current function is post and the user can post then post menu is made visible.
                        else if (wedgeFunction == "Post")
                        {
                            seeMorePost.Text = tweetToUse.Text;
                            seeMorePost.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                            cover.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                        }
                        break;
                    }
                }
            }
            //If the current post is a Reddit post, then the post is identified.
            else if (currentButton.Contains("Reddit"))
            {
                foreach (var item in topPosts)
                {
                    if (item.Id.ToString() == idToUse)
                    {
                        redditPostToUse = item;
                        //If the current function is too like a post then the Reddit upvote function is called.
                        if (wedgeFunction == "Like")
                        {
                            item.Upvote();
                            numberofExperimentalLikes++;
                            if (stageOfExperiment == 4 && experimentRunning && numberofExperimentalLikes == 2)
                            {
                                sw.Stop();
                                Debug.WriteLine("Fourth Elapsed={0}", sw.Elapsed);
                                Debug.WriteLine("Total number of clicks is: " + numberOfClicks);
                                double accuracyTotal = 4 / numberOfClicks * 100;
                                Debug.WriteLine("Accuracy of Task 4: " + accuracyTotal);
                                timeStamps[6] = (sw.Elapsed).ToString();
                                timeStamps[7] = numberOfClicks.ToString();
                                await Task.Delay(50);
                                numberOfClicks = 0;
                                stageOfExperiment++;
                                sw = new Stopwatch();
                                sw.Start();
                            }
                        }
                        //If current function is comment, then comment menu is made visible.
                        else if (wedgeFunction == "Comment")
                        {
                            generalTextInput.Visibility = Visibility.Visible;
                            submitComment.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                            cover.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                        }
                        //If current function is share and the user can share then share menu is made visible.
                        else if (wedgeFunction == "Share" && canShare)
                        {
                            canShare = false;
                            shareToReddit.Visibility = Visibility.Visible;
                            shareToTwitter.Visibility = Visibility.Visible;
                            shareToBoth.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                            cover.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                        }
                        //If current function is post and the user can post then post menu is made visible.
                        else if (wedgeFunction == "Post")
                        {
                            seeMorePost.Text = item.Listing.SelfText;
                            seeMorePost.Visibility = Visibility.Visible;
                            cover.Visibility = Visibility.Visible;
                            closeMenu.Visibility = Visibility.Visible;
                            anyMenuOpen = true;
                        }

                    }
                }
            }
            //If current function is post and the user can post then post menu is made visible.
            else if (wedgeFunction == "createPost" && canPost)
            {
                canPost = false;
                generalTextInput.Visibility = Visibility.Visible;
                closeMenu.Visibility = Visibility.Visible;
                cover.Visibility = Visibility.Visible;
                postToBoth.Visibility = Visibility.Visible;
                postToReddit.Visibility = Visibility.Visible;
                postToTwitter.Visibility = Visibility.Visible;
                anyMenuOpen = true;
                await Task.Delay(10);
            }
        }


        //This method checks a categorical tag of a post and returns true if that category is not currently filtered out.
        private Boolean checkTag(String check, String text)
        {
            if (check == "Sport" && sportBool)
            {
                return true;
            }
            else if (check == "tech" && techBool)
            {
                return true;
            }
            else if (check == "news" && newsBool)
            {
                return true;
            }
            else if (check == "uni" && uniBool)
            {
                return true;
            }
            else if (check == "Food" && foodBool)
            {
                return true;
            }
            //Machine learning Python file would run here. Returning the result and assigning a tag to the post.

            return false;
        }

        


        //This method assigns tags to Reddit posts based on the content of the post, the author of the post and the
        //the description of the account making the post.
        private String assignRedditTag(Post posts, Subreddit sub)
        {
            var info = reddit.Subreddit(posts.Subreddit).About();
            String description = info.Description;
            String name = sub.Name;
            String content = posts.Listing.SelfText;
            content = content.ToLower();
            name = name.ToLower();
            if (description.Contains("sport") || name.Contains("sport") || description.Contains("football") || content.Contains("sport") || content.Contains("snooker") || content.Contains("rugby") || content.Contains("manchester united") || content.Contains("hibernian") || content.Contains("james cahill") || content.Contains("james milner") || content.Contains("sean dyche") || content.Contains("tiger woods") || content.Contains("tennis") || content.Contains("hockey"))
            {
                return "Sport";
            }
            else if (description.Contains("university") || name.Contains("university") || content.Contains("university"))
            {
                return "Uni";
            }
            else if (description.Contains("news") || name.Contains("news") || content.Contains("news") || content.Contains("commons") || content.Contains("trump") || content.Contains("activist") || content.Contains("brexit"))
            {
                return "news";
            }
            else if (description.Contains("tech") || name.Contains("tech") || description.Contains("computer") || description.Contains("api") || description.Contains("windows") || content.Contains("computer") || content.Contains("tech") || content.Contains("windows") || content.Contains("samsung") || content.Contains("apple") || content.Contains("chrome") || content.Contains("data") || content.Contains("installed") || content.Contains("instagram"))
            {
                return "tech";
            }
            else if (description.Contains("food") || name.Contains("food") || content.Contains("food"))
            {
                return "Food";
            }
            return "misc";
        }

        //This method assigns tags to Twitter posts based on the content of the post, the author of the post and the
        //the description of the account making the post.
        private String assignTag(Tweetinvi.Models.ITweet timelineTweet)
        {
            String description = timelineTweet.CreatedBy.Description;
            String name = timelineTweet.CreatedBy.Name;
            String content = timelineTweet.FullText;
            content = content.ToLower();
            description = description.ToLower();
            name = name.ToLower();
            if (description.Contains("sport") || name.Contains("sport") || description.Contains("football") || content.Contains("sport") || content.Contains("snooker") || content.Contains("rugby") || content.Contains("manchester united") || content.Contains("hibernian") || content.Contains("james cahill") || content.Contains("james milner") || content.Contains("sean dyche") || content.Contains("tiger woods") || content.Contains("tennis") || content.Contains("hockey"))
            {
                return "Sport";
            }
            else if (description.Contains("university") || name.Contains("university") || content.Contains("university"))
            {
                return "Uni";
            }
            else if (description.Contains("news") || name.Contains("news") || content.Contains("news") || content.Contains("commons") || content.Contains("trump") || content.Contains("activist") || content.Contains("brexit"))
            {
                return "news";
            }
            else if (description.Contains("tech") || name.Contains("tech") || description.Contains("computer") || description.Contains("api") || description.Contains("windows") || content.Contains("computer") || content.Contains("tech") || content.Contains("windows") || content.Contains("samsung") || content.Contains("apple") || content.Contains("chrome") || content.Contains("data") || content.Contains("installed") || content.Contains("instagram"))
            {
                return "tech";
            }
            else if (description.Contains("food") || name.Contains("food") || content.Contains("food"))
            {
                return "Food";
            }
            return "misc";
        }

        //This method posts a comment that the user has created.
        //It checks what is the medium of the current post, calling the appropiate api method from the correct social media platform.
        async void postComment()
        {
            if (generalTextInput.Text != "")
            {
                replyMessage = generalTextInput.Text;
                if (currentMedium == "Twitter")
                {
                    var textToPublish = string.Format("@{0} {1}", tweetToUse.CreatedBy.ScreenName, replyMessage);
                    Tweet.PublishTweetInReplyTo(textToPublish, tweetToUse.Id);
                    if (stageOfExperiment == 1 && experimentRunning)
                    {
                        sw.Stop();
                        Debug.WriteLine("First Elapsed={0}", sw.Elapsed);
                        Debug.WriteLine("Total number of clicks is: " + numberOfClicks);
                        double accuracyTotal = 3 / numberOfClicks * 100;
                        Debug.WriteLine("Accuracy of Task 1: " + accuracyTotal);
                        timeStamps[0] = (sw.Elapsed).ToString();
                        timeStamps[1] = accuracyTotal.ToString();
                        numberOfClicks = 0;
                        stageOfExperiment++;
                        sw = new Stopwatch();
                        sw.Start();
                    }
                }
                else if (currentMedium == "Reddit")
                {
                    redditPostToUse.Reply(replyMessage);
                }
            }
            generalTextInput.Text = "";
            replyMessage = "";
            generalTextInput.Visibility = Visibility.Collapsed;
            submitComment.Visibility = Visibility.Collapsed;
            closeMenu.Visibility = Visibility.Collapsed;
            cover.Visibility = Visibility.Collapsed;
            anyMenuOpen = false;
            await Task.Delay(1000);
        }


        //This method posts a shares that the user has created.
        //It checks what is the medium of the current post, calling the appropiate api method from the correct social media platform.
        //If the post is being shared to non native platform then the text of the post is copied into a new post for that platform.
        private void sharePost(String option)
        {
            if (option == "shareToTwitter")
            {
                if (currentMedium == "Twitter")
                {
                    var tweetPost = Tweet.PublishRetweet(tweetToUse);
                }
                else if (currentMedium == "Reddit")
                {
                    var tweetPost = Tweet.PublishTweet(redditPostToUse.Listing.SelfText);
                }
                canShare = true;
                currentWedge = "";
                shareToBoth.Visibility = Visibility.Collapsed;
                shareToReddit.Visibility = Visibility.Collapsed;
                shareToTwitter.Visibility = Visibility.Collapsed;
                cover.Visibility = Visibility.Collapsed;
                closeMenu.Visibility = Visibility.Collapsed;
                anyMenuOpen = false;
            }
            else if (option == "shareToReddit")
            {
                if (currentMedium == "Twitter")
                {
                    var sub = reddit.Subreddit("r/SocialEyesPosts");
                    SelfPost myPost = sub.SelfPost("Post", tweetToUse.FullText).Submit();
                }
                else if (currentMedium == "Reddit")
                {
                    SelfPost myPost = (SelfPost)redditPostToUse;
                    myPost.Subreddit = "r/SocialEyesPosts";
                    myPost.Submit();
                }
                canShare = true;
                currentWedge = "";
                shareToBoth.Visibility = Visibility.Collapsed;
                shareToReddit.Visibility = Visibility.Collapsed;
                shareToTwitter.Visibility = Visibility.Collapsed;
                cover.Visibility = Visibility.Collapsed;
                closeMenu.Visibility = Visibility.Collapsed;
                anyMenuOpen = false;
            }
            else if (option == "shareToBoth")
            {
                if (currentMedium == "Twitter")
                {
                    var tweetPost2 = Tweet.PublishRetweet(tweetToUse);

                    var sub = reddit.Subreddit("r/SocialEyesPosts");
                    SelfPost myPost1 = sub.SelfPost("Post", tweetToUse.FullText).Submit();
                }
                else if (currentMedium == "Reddit")
                {
                    var tweetPost3 = Tweet.PublishTweet((String)redditPostToUse.Listing.SelfText);
                    SelfPost myPost2 = (SelfPost)redditPostToUse;
                    myPost2.Subreddit = "r/SocialEyesPosts";
                    myPost2.Submit();
                }
                if (stageOfExperiment == 2 && experimentRunning)
                {
                    sw.Stop();
                    Debug.WriteLine("Second Elapsed={0}", sw.Elapsed);
                    Debug.WriteLine("Total number of clicks is: " + numberOfClicks);
                    double accuracyTotal = 3 / numberOfClicks * 100;
                    Debug.WriteLine("Accuracy of Task 2: " + accuracyTotal);
                    timeStamps[2] = (sw.Elapsed).ToString();
                    timeStamps[3] = accuracyTotal.ToString();
                    numberOfClicks = 0;
                    stageOfExperiment++;
                    stageOfExperiment++;
                    sw = new Stopwatch();
                    sw.Start();
                }
                canShare = true;
                currentWedge = "";
                shareToBoth.Visibility = Visibility.Collapsed;
                shareToReddit.Visibility = Visibility.Collapsed;
                shareToTwitter.Visibility = Visibility.Collapsed;
                closeMenu.Visibility = Visibility.Collapsed;
                cover.Visibility = Visibility.Collapsed;
                anyMenuOpen = false;
            }
        }


        //This method posts a new post that the user has created.
        //It checks what is the medium of the current post, calling the appropiate api method from the correct social media platform
        private void postWithText(String option)
        {
            String postMessage = "";
            postMessage = generalTextInput.Text;
            closeOpenMenu();
            if (option == "postToTwitter")
            {
                var tweetPost = Tweet.PublishTweet(postMessage);
                if (stageOfExperiment == 3 && experimentRunning)
                {
                   // sw.Stop();
                    //Debug.WriteLine("Third Elapsed={0}", sw.Elapsed);
                    //Debug.WriteLine("Total number of clicks is: " + numberOfClicks);
                    //double accuracyTotal = 3 / numberOfClicks * 100;
                    //Debug.WriteLine("Accuracy of Task 3: " + accuracyTotal);
                    //timeStamps[4] = (sw.Elapsed).ToString();
                    //timeStamps[5] = accuracyTotal.ToString();
                    //await Task.Delay(50);
                    //numberOfClicks = 0;
                    //stageOfExperiment++;
                    //sw = new Stopwatch();
                    //sw.Start();
                }

            }
            else if (option == "postToReddit")
            {
                var sub = reddit.Subreddit("r/SocialEyesPosts");
                SelfPost myPost = sub.SelfPost("Post", postMessage).Submit();
            }
            else if (option == "postToBoth")
            {
                //var tweetPost = Tweet.PublishTweet(postMessage);
               // var sub = reddit.Subreddit("r/SocialEyesPosts");
               // SelfPost myPost = sub.SelfPost("Post", postMessage).Submit();
            }
            generalTextInput.Text = "";
            canPost = true;
            currentWedge = "";
        }


        //Some buttons have click based events that can be used for testing purposes.

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            pageScrollDown();
        }
        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            pageScrollUp();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            pageScrollHome();
        }
        private void Options_Click(object sender, RoutedEventArgs e)
        {
            socialMediaOptions.Visibility = Visibility.Visible;
            closeMenu.Visibility = Visibility.Visible;
            cover.Visibility = Visibility.Visible;
            anyMenuOpen = true;
        }

        private void FilterOptions_Click(object sender, RoutedEventArgs e)
        {
            filterOptions.Visibility = Visibility.Visible;
            closeMenu.Visibility = Visibility.Visible;
            cover.Visibility = Visibility.Visible;
            anyMenuOpen = true;
        }

        private void DwellOptions_Click(object sender, RoutedEventArgs e)
        {

        }

        private void ExitOptions_Click(object sender, RoutedEventArgs e)
        {

        }

        private void TextInput_Click(object sender, RoutedEventArgs e)
        {


        }

        private void CloseMenu_Click(object sender, RoutedEventArgs e)
        {
            closeOpenMenu();
        }
    }
}
