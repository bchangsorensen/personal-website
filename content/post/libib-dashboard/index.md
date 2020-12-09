---
title: "Adding flexdashboard widgets to blogdown sites"
categories: R
date: '2020-12-09'
image:
  preview_only: yes
share: no
summary: A workaround for hosting `flexdashboard` visualizations on `blogdown` sites using an iframe. 
tags: ["r", "visualization", "flexdashboard", "blogdown"]

authors: 
- admin
---

_Disclaimer: This is a work in progress, since I haven't figured out how to fully customize the layout to my liking. But hopefully this offers a starting point for other Hugo Academic users who are more familiar with HTML and CSS!_

## Motivation

I started writing this post as an excuse to try out a few more packages from the `htmlwidgets` family. When I came across the `slickR` package, I decided I would visualize some my personal reading data, which I've been tracking with [Libib.com](https://www.libib.com) for the last few years. I sketched out a final product that would use a `flexdashboard` layout to display some of my favorite titles in a `slickR` carousel, list the books I've read using `reactable`, and then visualize whatever trends I could find in my reading habits. In the end I opted for a simpler dashboard because I ran into a few unexpected roadblocks — namely that it was much harder to embed a `flexdashboard` on my `blogdown` site than I had anticipated.

I'm not the first `blogdown` user to run into this issue, and in my search for answers I came across several unresolved posts in the RStudio and `flexdashboard` community forums (like [this](https://community.rstudio.com/t/blogdown-and-flexdashboard/27842), [this](https://community.rstudio.com/t/host-flexdashboard-on-blogdown-site/76355), [this](https://github.com/rstudio/flexdashboard/issues/72), and [this](https://community.rstudio.com/t/rblogdown-and-flexdashboard-revistted/37064)). It seemed like a fairly common workaround was to host the `flexdashboard` `.html` file in the `static/` folder of your site's directory, and then link to it within the content of the post. While this approach technically allowed me to host a dashboard on my site [like so](https://www.benjaminsorensen.me/post/libib-dashboard-body/), it required the viewer to navigate away from the rest of my site and didn't feel integrated with the flow of my post. What I really wanted was to embed the dashboard within my post, so that all of my content would be in one place and immediately accessible to the reader.

After some more searching and a lot of tinkering, I figured out how to embed my dashboard, and you can see the results below. Scroll down to learn how it works!

<iframe class="flexdashboard" src="https://www.benjaminsorensen.me/post/libib-dashboard-body/" style = "height: 1070px; width: 720px"> </iframe>

## How-to

1. First we need to host our `flexdashboard` content on our site. I followed the steps in [this post](https://blogdown-demo.rbind.io/2017/09/06/adding-r-markdown-documents-of-other-output-formats/) about rendering abitrary `.Rmd` files on `blogdown` from the package's authors:

> + Go to your blogdown project's root directory and create a new folder called `R`
> + In that `R/` directory, create a new R script called `build.R` that contains 1 line of code that reads: `blogdown::build_dir('static')`
> + Add and save Rmd file(s) to your blogdown project in the `static/` directory. 
>   * In fact, you can add Rmd files within sub-directories such as `static/slides/`, `static/pdf/`, and/or `static/html/`
> + Serve your site 

2. Following these steps, I created a subdirectory called `static/dashboards/` to host my `.Rmd` file. Serving my site created a customized `.html` file formatted according to the `output: flexdashboard::flexdashboard` settings I configured in the YAML of my `.Rmd` file. This file doesn't play nice with regular `blogdown` posts, so it needed to be stored away from the `content/post` directory where my content usually lives. 

3. To be able to easily navigate to my new dashboard on the local version of my site, I followed [Mara Alexeev's advice here](https://community.rstudio.com/t/host-flexdashboard-on-blogdown-site/76355) and copied the new `.html` file to my `post/` folder. To keep things organized, I copied it into a new subdirectory called `post/libib-dashboard-body/`, and was able to see how it looked by navigating to `[my_local_network]/post/libib-dashboard-body/` on my local preview site. 

4. Note that this post (the one you're reading) isn't hosted in the same `static/` directory as the `.html` file specifying my dashboard. Instead, this post is rendered from a separate `.md` file in the usual `content/post/` directory. This allowed me to add more `markdown` content and integrate it with the rest of my site using `YAML` options like a title, custom HTML, and a header image.

5. To render the dashboard within this post, I simply embedded the new URL in an `<iframe>` tag and added it to the body of the `.md` file. And voilà! This line is all it took to render the dashboard you see above: 

```
<iframe class="flexdashboard" src="https://www.benjaminsorensen.me/post/libib-dashboard-body/" style = "height: 1070px; width: 720px"> </iframe>
```

## Limitations

While I was very excited to finally see my dashboard embedded in my post, I quickly noticed a few limitations that I still haven't fully resolved. Keep in mind that, at the time of this writing, I've only been fiddling with custom HTML and CSS for a few days, so it's very likely that I'm overlooking easy fixes to the problems described below. So if you have any suggestions or are able to take this concept farther than I was, [I'd love to hear from you!](mailto::bchangsorensen@gmail.com) 

* I haven't figured out how to expand the `<iframe>` tag beyond the default width of the body of my post, which is why my dashboard is so narrow. Ideally, I'd like the dashboard to stretch closer to the far right and left margins of the site, but after toying with some custom stylization I wasn't able to get anywhere. Since I couldn't figure this out I ended up re-designing my dashboard to fit the page.

* The `{.tabset}` option in `flexdashboard` doesn't seem to render properly in `blogdown`. I ended up dropping a visualization because I couldn't display it compactly without this feature. 

* Step 3 of the approach I'm taking involves copying the `flexdashboard`-rendered `.html` file from my `static/dashboards/` folder into its own `content/post/` folder, and I've had to repeat this step each time I re-rendered the dashboard. This doesn't take long, but it's not ideal and I'm sure it could be streamlined somehow. 


### Bonus visualization!

{{< figure src="bonus.png" title="Campaigns are unhealthy for reading habits :sweat_smile:" >}}
