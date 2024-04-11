# About 

This was not so much a project as it was a challenge inside of a project. I was given the opportunity to write this such that alerts sent out via email, push notifications, and a web api were not delivered on holidays.

After some research I also understood that calendars are cyclical in nature, so calculating each year over year would not be an issue. So I went about figuring out how each of the holidays are calculated, with the exception of Easter. I stumbled upon the United States Navy's algorithm online somewhere for calculating that. 

The easy ones were holidays like New Year's Day. Jan 1. every year, but as I progressed in the thought of how to do this I came up what I thought was a clever table design to negate the need for calculations for all holidays, if I could better describe the day, month, week, day of the week, etc. with the SQL. 

Needing this to be fast I also looked for ways to avoid looping. Then I discovered "Tally Tables", and Ultimately the "Ben-Gan" design, which is what I went with. 

This was a fun challenge I got done over a week in my spare time on other project related duties. 
