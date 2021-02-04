---
title: "Building a relational organizing program on a low-budget, local campaign"
categories: Campaigning
date: '2021-02-04'
image:
  preview_only: yes
share: false
summary: Taking advantage of MiniVAN's new quick lookup feature to run a makeshift relational program.
tags: ["campaigning", "blog"]

authors: 
- admin
---

These days, data and tech are a central part of just about every campaign's strategy and execution, and the growing field of progressive analytics has risen to meet this demand with a flush of talent and a suite of exciting new technologies that are changing the way elections are won, one race at a time. Consider the recent growth of relational organizing using apps like [Reach](https://www.reach.vote/), which empowers a campaign's volunteers to survey their own personal networks and leverage their relationships into votes. Reach was originally developed for Alexandria Ocasio-Cortez's first primary race in 2018, and has since been adopted by major campaigns like the 2020 Senate race I worked on in Montana, where a relational-first Native organizing program helped achieve record turnout in Indian country, and in Georgia, where the Jon Ossoff campaign used Reach to develop an [incredibly effective statewide community mobilization network](https://twitter.com/_joshuakravitz/status/1354596290198343680) that helped flip the Senate. 

Knowing all this, I was excited to pitch relational organizing to [Dr. Karen Pérez-Da Silva](https://karenperezdasilva.com/), whose school board campaign I've been volunteering on as a data and tech consultant.[^1] When I described the power of relational canvassing and shared my own experiences using Reach, Karen was immediately on board. In fact, the idea of relational canvassing came up organically during an early volunteer meeting, when I was asked whether I could use the voter file to target school teachers, since most of the volunteers (and Karen herself) are current or former educators with deep ties to the community. With traditional list-cutting tools, the answer would be no, but with a relational program and the right volunteers, I realized we could tap into the campaign's existing relationships to map out a unique base of support in our district.

Reach is accessibly priced, and to my mind, it remains the gold standard for relational organizing. However, I recognized a few drawbacks to the basic package that we could afford:

* The basic plan wouldn't include an integration with our voter database, meaning we'd need to manually upload canvass results on a regular basis to keep our data in sync. This is technically doable, but as any campaign staffer who's used VoteBuilder will tell you, constant bulk uploading is not a fun use of time. And no data engineer wants related data to live in two separate places where it can't be easily combined.

* Updates to the Reach voter file are priced with an additional fee. During early voting, it's incredibly useful to tell users who in their network has or hasn't already voted, but this is only possible if the data powering Reach can be kept up to date.

Neither of these issues are dealbreakers, but given the tight budget that comes with running for school board and my own limited time as a volunteer, I wanted to make sure I wasn't overlooking any reasonable alternatives. 

Then it occurred to me that we could try to use MiniVAN — the canvassing app that we already had access to through our VoteBuilder license — as a free alternative. MiniVAN is designed for door knocking, not relational canvassing, so I figured there would be a few drawbacks, but after testing it myself, I think it definitely has its advantages and has the potential to work well at a local scale. I also figured that we could test it out and upgrade to Reach at any point if it wasn't working for us — it certainly couldn't hurt to try. With some trial and error and a little bit of creativity, here's what I found.

### How it works

While MiniVAN isn't intended for relational organizing, it recently introduced a new "[quick lookup](https://blog.ngpvan.com/minivan-qlu)" feature that allows volunteers knocking a traditional door packet to find and survey non-targeted voters they happen to encounter along the way. If used effectively, this means that data can still be collected when the person behind a door isn't the voter the volunteer is looking for. It also means that anyone with a MiniVAN list can search the voter file for supporters, collect survey responses, and send that data back to the campaign. 

{{< figure src="minivan_reach.png" title="Examples of each app's search interface." >}}

There are a few key differences in the search functionality, and on each point Reach is superior. For instance, MiniVAN requires a first name, last name, and a 5-digit zip code, whereas Reach lets you use fuzzier search terms and can even help you find new voters by looking up addresses. MiniVAN's name search isn't exact, meaning you can search for someone named Bob even though they're registered as Robert, but it does seem pretty unforgiving of typos. However, the main sticking point turned out to be MiniVAN's zip code requirement. While it's easy enough to ask a voter you're already talking to which zip code they're registered under, it isn't something most users would know about their friends off the top of their heads. This poses a problem in smaller districts, because when canvassing my personal contacts, I'd want to know whether or not they actually live in my district before reaching out to ask for their support. With Reach I can check the voter file with a simple name search, but with MiniVAN, I need a zip code as well, and to get that right I'm probably going to need to talk to them first. Compared to Reach, this is a lot less efficient and could create a worse volunteer experience on a smaller campaign, since users would likely end up talking to friends who don't live in the right district.

But there does seem to be a workaround. While MiniVAN will reject invalid zip codes and won't return results for random guesses, I've been able to successfully find voters whose zip codes I didn't know by simply using *the most common* zip code in the district, even when that guess was incorrect. To make sure this wasn't a fluke, I pulled a random list of voters from different zip codes and searched for them in MiniVAN using the most common zip code as a stand-in, and even though the zip code I guessed was often incorrect, I was still able to find the voters I was looking for. This stand-in approach also worked for other common zip codes, though for whatever reason my searches failed when I tried guessing rare zip codes (anecdotally, these were zips representing < .1% of voters in the district). So it required a tiny bit of knowledge about the district to work, but that wasn't much of a barrier at all. 

### How it performs

Thanks to this solution, MiniVAN can be treated as a fully functional — though not fully optimized — relational organizing app. For a campaign on a tight budget and with a small electorate to target, this approach offers a great way for us to map out our community support and enrich our voter database at no additional cost. And while it's not as powerful as Reach and lacks some of the features that would help a more ambitious relational program scale up, it does offer some distinct advantages: 

* Quick lookup is included with a basic VoteBuilder license, and is accessible to anyone who can use MiniVAN. For most Democratic campaigns, this means it's essentially a free feature. 

* MiniVAN is probably already familiar to volunteers who have knocked doors for Democratic campaigns before, and they can use their existing ActionIDs to log in. This also means that a volunteer's relational contact attempts can be tracked alongside traditional contact attempts in VoteBuilder, and there's no need to try to match users across multiple systems. 

* Volunteers can easily sync their data back to the campaign's database — no bulk uploads required. Data can be inspected and committed to the database using VoteBuilder's MiniVAN commit system for door packets. 

* Survey results collected through quick lookup contain useful metadata that can be used to augment the relational program during early voting. E.g. the campaign can pull a list of supporters canvassed by a certain volunteer, and then help that volunteer call through their custom network during GOTV. 

There are still issues with using MiniVAN that could hopefully be resolved in future releases. For instance, there doesn't seem to be a way to see a voter's survey response history or voting status from the quick lookup view. This could lead to overlapping relational canvasses, where multiple volunteers reach out to the same people. Quick lookup is also only available when using a door packet, so a dummy list needs to be distributed to volunteers who want to use the app. I created a single-person list and used this to generate a packet and list number, which worked fine, though it feels a little clunky since volunteers will be ignoring the list and just using quick lookup. 

Still, these are problems that can be managed at our campaign's smaller scale. For instance, by hosting "friend banks" and introducing volunteers to our relational approach on a Zoom call, we can limit overlap between networks and make sure everyone has a productive experience using the app. Once trained, super volunteers can use MiniVAN on their own time to keep building their networks and collecting more data. And when early voting starts, we can pivot to a relational "chase" program that focuses on turning out existing networks with phone or text banks, using lists filtered by voting status, contact history, and support.

In the end, this approach is still experimental, and it certainly won't be a suitable solution for everyone. It has the potential to work in our case because our campaign is small, and we have specific needs and resources that happen to be conducive to a makeshift relational program. If we wanted to scale up our efforts significantly, or if we were in a bigger district, the downsides to this approach would grow more apparent and we would probably switch to a service like Reach. But for building out an initial network of support and collecting low-hanging data from supporters in our community, this solution has worked well so far, and it's easy to imagine that similarly positioned campaigns could benefit from the same approach if they want to dip their toes into relational organizing before committing to a contract with Reach or another service. 

At the end of the campaign — or maybe sooner, if we decide to change course before the election is over — I'll revisit this strategy and decide whether it really worked or not, or whether I regret not upgrading to a service like Reach sooner. But for now I see this as an exciting chance to bring some of the best ideas to come out of bigger campaigns to a much smaller local race. 

[^1]: As a testament to the power of relational organizing, consider the fact that I'm volunteering for Karen's campaign even though I never attended school in Beaverton — I've never even lived in Oregon. I was invited to help out by my girlfriend's mom, who's deeply involved in the campaign and knows Karen from their teaching days. Make those relational asks, people! 
