# WISP

## Installation

Clone the repository
```
git clone https://github.com/drobin03/wisp.git
```
Setup your Ruby on Rails Environment

Try this one-step installer: http://railsinstaller.org/en

Now prepare your environment
```
cd wisp
bundle
```
The bundle command should take a little bit of time. Once it is finished, move on to the next step.

### Database Setup
Install MySQL if you don't already have it: http://dev.mysql.com/downloads/installer/

Make sure that you have a user account "root" with no password

Create the database and migrate based on the specs
```
rake db:create db:migrate
```

### Populating the database

There are two ways to populate the database.

1. Use the 2 scripts that we created to scrape the data.
2. (Faster) Import our database dump into your local database

#### 1. Using the scripts
There are three scripts to run, they will typically take around 1 hour to complete. 

First, you need to download the latest speedtest data manually:
navigate to http://netindex.com in your browser.
Halfway down the page there is a link to download the source data, click it:
![enter image description here](https://drive.google.com/thumbnail?id=0Bz69MLkDoANhcXhoY1hTRUU0ajg&authuser=0&v=1416924401407&sz=w2560-h1255)

Once it is finished downloading, unzip the contents and move the city_isp_daily_speeds.csv into the project tmp folder:
```
mv city_isp_daily_speeds.csv wisp/tmp/speedtest_data/
```

Now run the script to parse out the Canadian data:
```
rake speedtest:split_canadian_data
```

Now you should have a canada.csv file in your tmp/speedtest_data/ folder.
Next, run the script to import all of the Canadian data into the database (This step will take the longest):
```
rake speedtest:collect_data
```

Finally, we need to grab the pricing data from canadianisp.ca. Run the crawler:
```
rake ispinfo:collect_data
```
Thats it! You have all the latest data!
#### 2. Import our database
Import the following file into your local database. It will save you some time since you don't need to run the scripts.

We have shared the database on google drive, copy it into your wisp/ folder: https://drive.google.com/file/d/0Bz69MLkDoANhZHZGV005QWFycms/view?usp=sharing
Then, to update your database:
```
cd wisp
mysql -u root wisp_development < db_dump_27-10-2014.sql
```
Thats it!

#### Test that the data import worked
To make sure it worked, start the rails console and print out a list of cities
```
rails c
irb(main):001:0> City.all.map(&:name)
``` 
The output of that command should be something like this:
```
irb(main):001:0> City Load (0.4ms)  SELECT `cities`.* FROM `cities`
irb(main):001:0> => ["Quebec", "Toronto", "Montreal", "Burnaby", "Windsor", "Vancouver", "London", "Victoria", "Ottawa", "Edmonton", "Kitchener", "Calgary", "Guelph", "Regina", "Fredericton", "New Westminster", "Gatineau", "Winnipeg", "Kanata", "Saskatoon", "Longueuil", "Chilliwack", "Langley", "Halifax", "Barrie", "Moncton", "Verdun", "Kelowna", "Markham", "Hamilton", "Nanaimo", "North Vancouver", "Brandon", "Scarborough", "Richmond Hill", "Timmins", "Belleville", "Thornhill", "Port Coquitlam", "Brampton", "Courtenay", "Oshawa", "Woodbridge", "LÃ©vis", "Oakville", "Sherbrooke", "Brantford", "Ajax", "Waterloo", "Niagara Falls", "Abbotsford", "Whitby", "Airdrie", "Newmarket", "Saint John", "Peterborough", "Lethbridge", "Granby", "North Bay", "Etobicoke", "Aurora", "Mississauga", "Sudbury", "Laval", "Grande Prairie", "Kamloops", "Prince George", "Fort McMurray", "Kingston", "Milton", "Cornwall", "Orangeville", "Duncan", "Medicine Hat", "Sault Sainte Marie", "Trois-Rivieres", "Thunder Bay", "Red Deer", "Pickering", "Repentigny", "Penticton", "Vernon", "Brossard", "Terrebonne", "Sydney", "Saint Catharines", "Saint-Hyacinthe", "Sherwood Park", "Dollard-des-Ormeaux", "Dartmouth", "Joliette", "Saint Albert", "Sarnia", "Campbell River", "Chicoutimi", "Drummondville", "Pierrefonds", "Surrey", "Vaudreuil", "Delta", "Coquitlam", "Maple Ridge", "Maple", "Richmond", "Charlottetown", "Burlington", "Cambridge", "Saint John's", "Blainville", "Lasalle", "St. John's"]
```

### Start your local server
```
rails s
```

## Pulling updates

Pull the latest changes from github
```
git pull
```

Apply any database migrations to your local database
```
rake db:migrate
```

If the Gemfile has changed, run the bundler, otherwise skip this step
```
bundle
```

Start the server
```
rails s
```